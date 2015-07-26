require 'rails_helper'

RSpec.describe "penalties/edit", type: :view do
  before(:each) do
    @penalty = assign(:penalty, Penalty.create!(
      :category => "MyString",
      :min => 1,
      :max => 1
    ))
  end

  it "renders the edit penalty form" do
    render

    assert_select "form[action=?][method=?]", penalty_path(@penalty), "post" do

      assert_select "input#penalty_category[name=?]", "penalty[category]"

      assert_select "input#penalty_min[name=?]", "penalty[min]"

      assert_select "input#penalty_max[name=?]", "penalty[max]"
    end
  end
end
