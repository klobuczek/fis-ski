require 'spec/spec_helper'

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

end