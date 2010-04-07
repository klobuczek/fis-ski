require 'spec/spec_helper'

describe Category, "#race_category" do
  it "returns A for no M3 results" do
    Category.new(:category => '3').race_category('M').should == 'A'
  end
end