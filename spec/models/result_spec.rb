require 'spec/spec_helper'

describe Result, "#cup_points" do
  [[1, 1, 25], [2, 1, 20], [3, 1, 15], [4, 1, 12], [17, 1, 0], [1, 2, 50]].each do |rank, factor, cup_points|
    it "returns #{cup_points} for rank #{rank}" do
      result = Result.new(:rank => rank)
      result.expects(:race).returns(mock(:factor => factor))
      result.cup_points.should == cup_points
    end
  end
  it "should calculate points only once" do
    result = Result.new(:rank => 1)
    result.expects(:race).returns(mock(:factor => 1))
    2.times {result.cup_points}
  end
end

describe Result, "#group_by_competitor" do
  it "should empty array for empty results" do
    Result.expects(:find).returns([])
    Result.for(2010,'M',4).group_by_competitor.should == []
  end

  it "should group results by competitors" do
    Result.expects(:find).returns([r1=competitor_stub(1), r2=competitor_stub(1)])
    Result.for(2010,'M',4).group_by_competitor.first.results.should include(r1,r2)
  end
end

def competitor_stub id
   stub(:competitor => Competitor.new(:id => id), :competitor_id => id)
end