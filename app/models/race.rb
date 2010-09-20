class Race < ActiveRecord::Base
  LOADED = 'loaded'
  FMC = {:category => %w{FMC WCM}}

  has_many :results, :conditions => "overall_rank is not null", :order => "overall_rank"
  has_many :starts, :class_name => Result, :conditions => "failure is null or failure <> 'DNS'", :order => "failure, overall_rank"

  scope :to_be_scored, lambda { |season| in_season(season).where("comments is null or comments != 'Cancelled'").where("status is null or status != '#{LOADED}'") }
  scope :fmc, where(FMC)

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
      return unless season >= 2010
      #Consider finals with double points to be either 2 consecutive days at the end of the season or the last race of WMC
      Race.update_all 'factor=1', :season => season
      ('A'..'C').each do |age_group|
        finals = in_season(season).where(:age_group => age_group, :category => 'FMC').order('date desc').limit(2)
        return if finals.count < 2 or finals.last.date.month < 2
        finals.first.double_points
        finals.last.double_points if finals.first.date - 1.day == finals.last.date
      end
    end

    private
    def in_season season
      where(:season => season.to_i)
    end

    def pending season, gender
      to_be_scored(season).fmc.where(:gender => gender).count
    end

    def scored season, age_group
      in_season(season).fmc.where(:age_group => age_group, :status => LOADED).count
    end
  end

  def update_age_class_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0, r.overall_rank-1].inject(1) { |count, p| p.overall_rank < r.overall_rank and AgeClass.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count })
    end
  end

  def double_points
    update_attribute(:factor, 2)
  end
end