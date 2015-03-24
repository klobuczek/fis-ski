class Race < ActiveRecord::Base
  LOADED = 'loaded'
  FMC = {:category => %w{FMC WCM}}

  has_many :results, -> { where("overall_rank is not null").order("overall_rank") }
  has_many :starts, -> { where("failure is null or failure <> 'DNS'").order("failure, overall_rank") }, class_name: Result

  scope :to_be_scored, lambda { |season| in_season(season).where("comments is null or comments != 'Cancelled'").where("status is null or status != '#{LOADED}'") }
  scope :fmc, -> { where(FMC) }

  class << self
    def remaining gender, age_class=nil
      season = Season.current
      count = pending(season, gender)
      return count if gender == 'L'
      return count/2 if count%2 == 0

      counts = {}
      ['A', 'B'].each { |c| counts[c]=scored(season, c) }

      return count/2 if counts[AgeClass.new(:season => season, :age_class => age_class).age_group(gender)] == counts.values.max

      count/2 + 1
    end

    def completed season, gender, age_class
      scored(season, AgeClass.new(:season => season, :age_class => age_class).age_group(gender))
    end

    def update_factors(season)
      return unless season >= 2010 && last_fmc_race = fmc_races(season).first
      #Consider finals with double points to be either 2 consecutive days at the end of the season or the last race of WMC
      #At the begin of the season codex may be missing so do not double factors until March
      Race.where(season: season).update_all(factor: 1)
      fmc_races(season).where('date >= ?', [last_fmc_race.date - 1.day, Date.new(season, 3, 1)].max).all.each do |race|
        race.double_points
      end
    end

    private
    def in_season season
      where(:season => season.to_i)
    end

    def fmc_races season
      in_season(season).where(:category => 'FMC').order('date desc')
    end

    def pending season, gender
      to_be_scored(season).fmc.where(:gender => gender).count
    end

    def scored season, age_group
      in_season(season).fmc.where(:age_group => age_group, :status => LOADED).count
    end
  end

  def update_age_class_ranks
    age_class_map = Hash.new(0)
    results.each do |r|
      r.update_attribute(:rank, age_class_map[AgeClass.new(season: season, year: r.competitor.year).to_i]+=1)
    end
  end

  def double_points
    update_attribute(:factor, 2)
  end
end