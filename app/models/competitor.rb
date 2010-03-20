class Competitor < ActiveRecord::Base
  include FisModel

  attr_accessor :rank, :tie
  attr_accessor :results

  def qualified?
    results.size >= 6
  end

  def cup_points
    @cup_points ||= calculate 9, :cup_points
  end

  def fis_points
    @fis_points ||= calculate 9, :fis_points
  end

  def self.classify! competitors, qualified_only=false
    competitors.reject!{|c| not c.qualified?} if qualified_only
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
  def calculate max, attr
    sum = 0.0
    results.each_with_index {|r, i| sum += r.send attr if i < max}
    sum
  end
end
