class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
  belongs_to :race

  scope :successful, -> { where("rank is not null") }
  scope :started, -> { where("failure is null or failure <> 'DNS'") }

  class << self
    def group_by_competitor season, gender, age_class
      results = by_age_class season, gender, age_class
      results.inject({}) do |h, r|
        ((h[r.competitor_id] ||= r.competitor).results ||= []) << r
        h
      end.values
    end

    private
    def where_age_class(season, gender, age_class)
      includes(:competitor, :race).where(:races => Race::FMC).started.where(:races => {:season => season, :gender => gender}, :competitors => {:year => age_class.min_year..age_class.max_year})
    end

    def by_age_class season, gender, age_class
      where_age_class season, gender, AgeClass.new(:season => season, :age_class => age_class)
    end
  end

  def cup_points
    @cup_points ||=
        ((rank.nil? or rank > 15) ? 0 : rank > 3 ? 16 - rank : 30 - 5*rank)*race.factor
  end

  def successful?
    rank
  end

end