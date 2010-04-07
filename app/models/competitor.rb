class Competitor < ActiveRecord::Base
  include FisModel

  attr_accessor :rank, :tie
  attr_accessor :results

  def qualified? remaining=0
    results.size >= season.min_races - remaining
  end

  def cup_points
    @cup_points ||= calculate :cup_points
  end

  def fis_points
    @fis_points ||= calculate :fis_points
  end

  def self.classify! competitors, remaining, filter='contetion'
    competitors.reject! { |c| !c.qualified?(remaining) } unless filter == 'all'
    competitors.each {|c| c.results.sort!}
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

  private
  def season
    @season ||= Season.new results.first.race.date
  end

  def calculate attr
    sum = 0.0
    results.each_with_index {|r, i| sum += r.send attr if i < season.max_races}
    sum
  end

end
