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

describe Result, "#by_category" do
  it "should empty array for empty results" do
    Result.expects(:by_age_class).returns([])
    Result.group_by_competitor(2010,'M',4).should == []
  end

  it "should group results by competitors" do
    Result.expects(:by_age_class).returns([r1=competitor_stub(1), r2=competitor_stub(1)])
    Result.group_by_competitor(2010,'M',4).first.results.should include(r1,r2)
  end

  it "should return nothing" do
    Result.send(:by_age_class, 2010, 'M', 4 ).should be_empty
  end

  it "should return result`" do
    result = Factory(:result)
    Result.send(:by_age_class, Season.current, 'M', 4 ).should == [result]
  end
end

describe Result, "#sort!" do
  it "should sort correctly" do
    [r1 = Factory.build(:result, :rank => nil, :fis_points => nil), r2 = Factory.build(:result, :rank => 20, :fis_points => 100)].sort.should == [r2, r1]
  end
end

def competitor_stub id
   stub(:competitor => Competitor.new(:id => id), :competitor_id => id)
end