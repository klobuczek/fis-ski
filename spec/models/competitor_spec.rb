describe Competitor, "#calculate" do
  it "returns 0 for no results" do
      c=Competitor.new
      c.expects(:results).returns([])
      c.send(:calculate, :any_attr).should == 0.0
  end

  it "sums up points for less than max results" do
      c=Competitor.new
      c.expects(:results).returns((1..3).map{|p| stub(:any_attr => p)})
      c.stubs(:season).returns(stub(:max_races => 4))
      c.send(:calculate, :any_attr).should == 6.0
  end

  it "sums up points for more than max results" do
      c=Competitor.new
      c.expects(:results).returns((1..6).map{|p| stub(:any_attr => p)})
      c.stubs(:season).returns(stub(:max_races => 4))
      c.send(:calculate, :any_attr).should == 10.0
  end

  it "should sort correctly" do
    r1 = Factory(:result, :rank => nil, :fis_points => nil)
    r2 = Factory(:result, :rank => 20, :fis_points => 100)
    r1.competitor.results=[r1,r2]
    r1.competitor.results.sort!
    r1.competitor.results.should == [r2,r1]
  end
end