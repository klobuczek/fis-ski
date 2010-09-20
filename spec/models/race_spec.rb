require 'spec/spec_helper'

describe Race, "#pending" do
  it "returns 0 for no races" do
    Race.send(:pending, Season.current, 'L').should == 0
  end

  it "returns 1 for non completed race" do
    Factory :race
    Race.send(:pending, Season.current, 'M').should == 1
  end
end

describe Race, "#completed" do
  it "returns 0 for no races" do
    Race.send(:scored, Season.current, 'A').should == 0
  end

  it "returns 1 for completed race" do
    Factory :race, :status => Race::LOADED,  :age_group => 'A'
    Race.send(:scored, Season.current, 'A').should == 1
  end
end

describe Race, "#remaining" do
  [0, 1].each do |n|
    it "returns #{n} for #{0} races" do
      Race.expects(:pending).returns(n)
      Race.remaining('L').should == n
    end
  end

  it "returns 1 for 2 pending 'A' races" do
    Race.expects(:pending).returns(2)
    Race.remaining('M', 3).should == 1
  end

  it "returns 1 for 3 pending 'M', 3 completed 'A' and 2 completed 'B' races" do
    Race.expects(:pending).returns(3)
    Race.expects(:scored).times(2).returns(3, 2)
    Race.remaining('M', 3).should == 1
  end
end

describe Race, "#results" do
  it "returns successful results" do
    Factory :result
    Race.first.results.count.should == 1
  end

  it "returns no successful results" do
    Factory :result, :overall_rank => nil, :failure => 'DSQ'
    Race.first.results.count.should == 0
  end
end

def create_race options={}
  Race.create!({:gender => 'L', :codex => 1, :season => Season.current, :date => Time.now, :place => 'anywhere', :nation => 'any'}.merge(options))
end