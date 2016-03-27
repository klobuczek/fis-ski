class Competitor < ActiveRecord::Base
  include FisModel
  include FisPointsCalculator::Competitor

  attr_accessor :rank, :tie, :season_results

  def qualified? remaining=0, rule, season, discipline
    season_results.select(&:successful?).size >= rule.min_races(season, discipline) - remaining
  end

  def cup_points
    @cup_points ||= calculate :cup_points
  end

  def race_points
    @race_points ||= calculate :race_points
  end

  def self.classify! competitors, rule, remaining, filter='contetion', discipline
    competitors.reject! { |c| !c.qualified?(remaining, rule, c.season, discipline) and c.season.advanced? } unless filter == 'all'
    competitors.each { |c| c.season_results.each { |r| r.rule = rule; r.discipline = discipline }.sort! }
    previous = nil
    competitors.sort!.each_with_index do |c, i|
      if previous and (previous.cup_points == c.cup_points)
        previous.tie=c.tie=true
      else
        c.tie = false
      end
      c.rank = i + 1
      previous = c
    end
  end

  def season
    @season ||= Season.new season_results.first.race.date
  end

  private
  def calculate attr
    sum = 0.0
    season_results.each_with_index { |r, i| sum += r.send attr if r.send(attr) and i < r.rule.max_races(season, r.discipline) }
    sum
  end
end