module FisPointsCalculator
  module Competitor
    extend ActiveSupport::Concern

    included do
      has_many :results, inverse_of: :competitor
      has_many :races, through: :results
      attr_accessor :fis_points
    end

    def two_best_results(options)
      results.successful.includes(:race).where.not(races: {penalty: nil}).select("races.penalty + race_points as fis_points").where(races: options).order('fis_points').limit(2)
    end

    def add_fis_points_before race
      self.fis_points ||= fis_points_before(race).try(:round, 2)
    end

    def fis_points_before(race)
      last_good_season = races.where("season < ?", race.season).where(discipline: race.discipline).order("season desc").distinct.limit(1).pluck(:season).first
      if last_good_season
        bl = two_best_results(season: last_good_season, discipline: race.discipline)
        bl_points = points bl, 1.5 ** (race.season - 1 - last_good_season)
      end
      nl = two_best_results(race.attributes.slice 'season', 'discipline').where("races.date < ?", race.date)
      nl_points = points nl

      !bl.blank? && (nl.blank? || nl.size == 1 || nl_points > bl_points) ? bl_points : nl_points
    end

    def points season_best_results, old_results_factor = 1
      season_best_results = season_best_results.to_a
      if season_best_results.blank?
        nil
      else
        season_best_results.sum(&:fis_points)/season_best_results.size * (season_best_results.size == 1 ? 1.2 : 1) * old_results_factor
      end
    end
  end

  module Race
    extend ActiveSupport::Concern

    included do
      scope :loaded, -> { where(status: ::Race::LOADED).order(:date) }
    end

    class_methods do
    end

    ZERO_PENALTY_RACE_COUNT = 30
    EARLIEST_PENALTY_SEASON = 2004

    def add_fis_points_at_start(starts)
      starts.each { |result| result.competitor.add_fis_points_before(self) }
    end

    def complete_results
      add_fis_points_at_start ::Result.add_ranks(results.started.includes(:competitor))
    end

    def calculate_penalty
      starts = complete_results
      b = starts.map(&:competitor_capped_fis_points).sort[0..4].sum
      top_ten = starts.select { |r| r.rank && r.rank <= 10 }
      return nil if top_ten.length < 5 || top_ten.count(&:competitor_fis_points) < 3
      best_five_finishers = top_ten.sort { |a, b| a.compare b, [:competitor_fis_points, 1], [:race_points, -1] }[0..4]
      a = best_five_finishers.sum(&:competitor_capped_fis_points)
      c = best_five_finishers.sum(&:capped_race_points)
      ((a+b-c)/10).round(2)
    end


    def update_penalty
      penalty = season < EARLIEST_PENALTY_SEASON || too_few_races_before ? 0 : calculate_penalty
      update_attribute :penalty, penalty && [penalty, 0].max
    end

    def too_few_races_before
      ::Race.loaded.where("date < ?", date).where(attributes.slice('discipline', 'age_group')).where.not(penalty: nil).count < ZERO_PENALTY_RACE_COUNT
    end
  end

  module Result
    extend ActiveSupport::Concern

    included do
      delegate :fis_points, to: :competitor, prefix: true
    end

    FIS_POINTS_CAP_FACTOR = {
        'Downhill' => 310,
        'Super G' => 250,
        'Giant Slalom' => 200,
        'Slalom' => 145
    }

    def competitor_capped_fis_points
      cap competitor.fis_points
    end

    def capped_race_points
      cap race_points
    end

    def fis_points
      (race.penalty + race_points).round(2) if race.penalty
    end

    private
    def cap points
      [FIS_POINTS_CAP_FACTOR[race.discipline], points].compact.min
    end
  end
end
