class Result < ActiveRecord::Base
  include FisModel
  include FisPointsCalculator::Result

  belongs_to :competitor, inverse_of: :results
  belongs_to :race, inverse_of: :results

  scope :successful, -> { where.not time: nil }
  scope :started, -> { where(failure: [nil, :DSQ, :DNF]) }

  attr_accessor :rank, :handicapped_time

  class << self
    def group_by_competitor season, age_group, age_class, discipline, rule=Rule.new
      handicap = age_class ? 0 : rule.handicap
      group_by(group_by(by_age_class(season, age_group, age_class, discipline), :race_id).
                   each { |g| add_ranks(g, handicap) }.flatten,
               :competitor_id).
          map { |g| g.first.competitor.tap { |c| c.season_results = g } }
    end

    def add_ranks(results, handicap=0)
      rank = 0
      previous_time = nil
      sort_with_handicap(results, handicap).each_with_index do |result, index|
        next unless result.time
        result.time_with_handicap(handicap)
        if result.handicapped_time != previous_time
          rank = index + 1
          previous_time = result.handicapped_time
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

    def sort_with_handicap results, handicap
      results.sort_by { |r| r.time_with_handicap(handicap) || 99999 }
    end
  end

  def time_with_handicap handicap
    @handicapped_time ||= time * (1 - handicap/100*(race.season - competitor.year - 30)) if time && competitor.year
  end

  def cup_points
    @cup_points ||= (rule.cup_points rank)*race.factor
  end

  def successful?
    time
  end

end