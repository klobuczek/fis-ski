require 'rails_helper'

RSpec.describe "penalties/index", type: :view do
  before(:each) do
    assign(:penalties, [
      Penalty.create!(
        :category => "Category",
        :min => 1,
        :max => 2
      ),
      Penalty.create!(
        :category => "Category",
        :min => 1,
        :max => 2
      )
    ])
  end

  it "renders a list of penalties" do
    render
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
