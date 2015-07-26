require 'rails_helper'

RSpec.describe "penalties/new", type: :view do
  before(:each) do
    assign(:penalty, Penalty.new(
      :category => "MyString",
      :min => 1,
      :max => 1
    ))
  end

  it "renders new penalty form" do
    render

    assert_select "form[action=?][method=?]", penalties_path, "post" do

      assert_select "input#penalty_category[name=?]", "penalty[category]"

      assert_select "input#penalty_min[name=?]", "penalty[min]"

      assert_select "input#penalty_max[name=?]", "penalty[max]"
    end
  end
end
