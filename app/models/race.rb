class Race < ActiveRecord::Base
  LOADED = 'loaded'

  has_many :results, :order => "overall_rank"

  named_scope :pending, lambda { |season, gender| {:conditions => ["season = ? and gender = ? and (comments is null or comments != 'Cancelled') and (status is null or status != '#{LOADED}')", season.to_i, gender]} }
  named_scope :completed, lambda { |season, race_category| {:conditions => {:season => season.to_i, :race_category => race_category, :status => LOADED}} }

  def self.remaining gender, category=nil
    season = Season.current
    count = pending(season, gender).count
    return count if gender == 'L'
    return count/2 if count%2 == 0

    counts = {}
    ['A', 'B'].each { |c| counts[c]=completed(season, c).count }

    return count/2 if counts[Category.new(:season => season, :category => category).race_category(gender)] == counts.values.max

    count/2 + 1
  end

  def self.completed_races_count season, gender, category
     completed(season, Category.new(:season => season, :category => category).race_category(gender)).count
  end

  def update_category_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0, r.overall_rank-1].inject(1) {|count, p| p.overall_rank < r.overall_rank and Category.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count})
    end
  end

end