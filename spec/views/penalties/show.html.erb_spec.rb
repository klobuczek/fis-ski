require 'rails_helper'

RSpec.describe "penalties/show", type: :view do
  before(:each) do
    @penalty = assign(:penalty, Penalty.create!(
      :category => "Category",
      :min => 1,
      :max => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
