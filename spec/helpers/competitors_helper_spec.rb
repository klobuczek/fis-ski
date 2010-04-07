require 'spec/spec_helper'

describe CompetitorsHelper, "#showing_both?" do
  include ApplicationHelper
  include CompetitorsHelper

  it "returns true if filter all" do
      params[:filter] = 'all'
      showing_both?.should be_true
  end

  it "returns true if minimum races completed" do
      params[:season] = 2010
      Race.expects(:count).returns(6)
      expects(:season_completed?).returns(false)
      showing_both?.should be_true
  end
end