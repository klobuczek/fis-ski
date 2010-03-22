class Race < ActiveRecord::Base
  has_many :results, :order => "overall_rank"

  def self.remaining gender
    count = Race.count(:conditions => ["season = ? and gender = ? and (comments is null or comments != 'Cancelled') and (status is null or status != 'loaded')", Season.current.to_i, gender])
    gender =='M' ? (count + 1)/2 : count
  end

  def update_category_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0,r.overall_rank-1].inject(1) {|count, p| p.overall_rank < r.overall_rank and Category.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count})
    end
  end
end