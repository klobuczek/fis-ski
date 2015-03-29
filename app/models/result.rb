class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
  belongs_to :race

  scope :successful, -> { where("rank is not null") }
  scope :started, -> { where("failure is null or failure <> 'DNS'") }

  class << self
    def group_by_competitor season, gender, age_class, discipline
      results = by_age_class season, gender, age_class, discipline
      results.inject({}) do |h, r|
        ((h[r.competitor_id] ||= r.competitor).results ||= []) << r
        h
      end.values
    end

    private
    def where_age_class(age_class, options)
      includes(:competitor, :race).where(:races => Race::FMC).started.where(:races => options.select { |_, v| v }, :competitors => {:year => age_class.min_year..age_class.max_year})
    end

    def by_age_class season, gender, age_class, discipline
      where_age_class AgeClass.new(:season => season, :age_class => age_class), season: season, gender: gender, discipline: discipline
    end
  end

  def cup_points
    @cup_points ||= (rule.cup_points rank)*race.factor
  end

  def successful?
    rank
  end

end