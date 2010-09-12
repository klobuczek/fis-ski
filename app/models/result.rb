class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
  belongs_to :race

  class << self
    def group_by_competitor season, gender, age_category
      results = by_age_category season, gender, age_category
      results.inject({}) do |h, r|
        ((h[r.competitor_id] ||= r.competitor).results ||= []) << r
        h
      end.values
    end

    private
    def by_category(season, gender, category)
      includes(:competitor, :race).where(:races => {:season => season, :gender => gender}, :competitors => {:year => category.min_year..category.max_year})
    end

    def by_age_category season, gender, age_category
      by_category season, gender, Category.new(:season => season, :category => age_category)
    end
  end

  def cup_points
    @cup_points ||=
            (rank <= 3 ? 30 - 5*rank : rank <= 15 ? 16 - rank : 0)*race.factor
  end
end