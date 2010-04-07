require 'spec/spec_helper'

describe Race, "#pending" do
  it "returns 0 for no races" do
    Race.pending(Season.current, 'L').count.should == 0
  end

  it "returns 1 for non completed race" do
    create_race
    Race.pending(Season.current, 'L').count.should == 1
  end
end

describe Race, "#completed" do
  it "returns 0 for no races" do
    Race.completed(Season.current, 'A').count.should == 0
  end

  it "returns 1 for completed race" do
    create_race :status => Race::LOADED, :gender => 'M', :race_category => 'A'
    Race.completed(Season.current, 'A').count.should == 1
  end
end

describe Race, "#remaining" do
  [0, 1].each do |n|
    it "returns #{n} for #{0} races" do
      Race.expects(:count).returns(n)
      Race.remaining('L').should == n
    end
  end

  it "returns 1 for 2 pending 'A' races" do
    Race.expects(:count).returns(2)
    Race.remaining('M', 3).should == 1
  end

  it "returns 1 for 3 pending 'M', 3 completed 'A' and 2 completed 'B' races" do
    Race.expects(:count).times(3).returns(3, 3, 2)
    Race.remaining('M', 3).should == 1
  end
end

def create_race options={}
  Race.create!({:gender => 'L', :codex => 1, :season => Season.current, :date => Time.now, :place => 'anywhere', :nation => 'any'}.merge(options))
end