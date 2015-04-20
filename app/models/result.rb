class Result < ActiveRecord::Base
  include FisModel
  belongs_to :competitor
  belongs_to :race

  scope :successful, -> { where("time is not null") }
  scope :started, -> { where("failure is null or failure <> 'DNS'") }

  attr_accessor :rank

  class << self
    def group_by_competitor season, age_group, age_class, discipline
      group_by(
          group_by(by_age_class(season, age_group, age_class, discipline), :race_id).each { |g| add_ranks(g) }.flatten,
          :competitor_id).
          map { |g| g.first.competitor.tap { |c| c.results = g } }
    end

    def add_ranks(sorted_results)
      rank = 0
      previous_time = nil
      sorted_results.each_with_index do |result, index|
        next unless result.time
        if result.time != previous_time
          rank = index + 1
          previous_time = result.time
        end
        result.rank = rank
      end
    end

    private
    def where_age_class(age_class, options)
      includes(:competitor, :race).where(:races => Race::FMC).where(races: {gender: age_class.gender}).started.where(:races => options.select { |_, v| v }, :competitors => {:year => age_class.min_year..age_class.max_year}).order('race_id, -time desc')
    end

    def by_age_class season, age_group, age_class, discipline
      where_age_class AgeClass.new(:season => season, :age_class => age_class, age_group: age_group), season: season, discipline: discipline
    end

    def group_by results, attr
      results.inject({}) do |h, r|
        (h[r.send attr] ||= []) << r
        h
      end.values
    end

  end

  def cup_points
    @cup_points ||= (rule.cup_points rank)*race.factor
  end

  def successful?
    time
  end

end