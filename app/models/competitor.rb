class Competitor < ActiveRecord::Base
  include FisModel

  attr_accessor :rank, :tie
  attr_accessor :results

  def qualified? remaining=0
    results.select(&:successful?).size >= season.min_races - remaining
  end

  def cup_points
    @cup_points ||= calculate :cup_points
  end

  def fis_points
    @fis_points ||= calculate :fis_points
  end

  def self.classify! competitors, rule, ranking_method, remaining, filter='contetion'
    competitors.reject! { |c| !c.qualified?(remaining) and c.season.advanced? } unless filter == 'all'
    competitors.each { |c| c.results.each { |r| r.rule = rule; r.ranking_method = ranking_method }.sort! }
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
    @season ||= Season.new results.first.race.date
  end

  private
  def calculate attr
    sum = 0.0
    results.each_with_index { |r, i| sum += r.send attr if r.send(attr) and i < season.max_races }
    sum
  end
end