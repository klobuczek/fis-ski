require 'spec/spec_helper'

describe FisParser, "#update_events" do

  it "should not create races if no races found" do
    FisParser.send(:fetch_races, Season.current.to_i, path(:no_races_found))
    Race.count == 0
  end

  it "should record failures" do
    FisParser.send(:fetch_results, Factory(:race, :href => path(:results_with_failures)))
    Result.where(:failure => 'DSQ').count.should > 0
  end

  it "should convert integer values" do
    FisParser.send(:i, [Nokogiri::HTML('&nbsp;5200921')],0).should == 5200921
  end
end

def path name
  File.new("#{::Rails.root}/spec/documents/#{name}.html").path
end

