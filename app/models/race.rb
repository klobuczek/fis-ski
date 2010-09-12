class Race < ActiveRecord::Base
  LOADED = 'loaded'

  has_many :results, :order => "overall_rank"

  class << self
    def remaining gender, category=nil
      season = Season.current
      count = pending(season, gender)
      return count if gender == 'L'
      return count/2 if count%2 == 0

      counts = {}
      ['A', 'B'].each { |c| counts[c]=scored(season, c) }

      return count/2 if counts[Category.new(:season => season, :category => category).race_category(gender)] == counts.values.max

      count/2 + 1
    end

    def completed season, gender, category
      scored(season, Category.new(:season => season, :category => category).race_category(gender))
    end

    private
    def in_season season
      where(:season => season.to_i)
    end

    def pending season, gender
      in_season(season).
              where(:gender => gender).
              where("comments is null or comments != 'Cancelled'").
              where("status is null or status != '#{LOADED}'").
              count
    end

    def scored season, race_category
      in_season(season).where(:race_category => race_category, :status => LOADED).count
    end
  end

  def update_category_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0, r.overall_rank-1].inject(1) { |count, p| p.overall_rank < r.overall_rank and Category.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count })
    end
  end
end