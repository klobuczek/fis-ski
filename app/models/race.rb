class Race < ActiveRecord::Base
  has_many :results, :order => "overall_rank"

  def update_category_ranks
    results.each do |r|
      r.update_attribute(:rank, results[0,r.overall_rank-1].inject(1) {|count, p| p.overall_rank < r.overall_rank and Category.same?(season, p.competitor.year, r.competitor.year) ? count + 1 : count})
    end
  end
end