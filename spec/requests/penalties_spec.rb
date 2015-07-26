require 'rails_helper'

RSpec.describe "Penalties", type: :request do
  describe "GET /penalties" do
    it "works! (now write some real specs)" do
      get penalties_path
      expect(response).to have_http_status(200)
    end
  end
end
