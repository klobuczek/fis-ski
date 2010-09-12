require 'spec/spec_helper'

describe CompetitorsHelper, "#showing_both?" do
  include ApplicationHelper
  include CompetitorsHelper

  it "returns true if filter all" do
      stubs(:params).returns(:filter => 'all')
      showing_both?.should be_true
  end

  it "returns true if minimum races completed" do
      stubs(:params).returns({})
      stubs(:season).returns(Season.new 2010)
      expects(:completed_min_races?).returns(true)
      expects(:season_completed?).returns(false)
      showing_both?.should be_true
  end

  it "should be able to call season_completed?" do
    pending
    assert season_completed?
  end
end