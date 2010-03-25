class Race < ActiveRecord::Base
  has_many :results, :order => "overall_rank"

  def self.remaining gender, category
    count = Race.count(:conditions => ["season = ? and gender = ? and (comments is null or comments != 'Cancelled') and (status is null or status != 'loaded')", Season.current.to_i, gender])
    return count if gender == 'L'
    return count/2 if count%2 == 0

    counts = {}
    ['A', 'B'].each do |c|
      counts[c]=Race.count(:conditions => ["season = ? and gender = ? and race_category = ? and status = 'loaded'", Season.current.to_i, gender, c])
    end

    return count/2 if counts[Category.new(:season => Season.current.to_i, :category => category).race_category(gender)] == counts.values.max

    count/2 + 1
  end

  def update_category_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0, r.overall_rank-1].inject(1) {|count, p| p.overall_rank < r.overall_rank and Category.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count})
    end
  end

end