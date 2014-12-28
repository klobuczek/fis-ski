describe CompetitorsHelper, :type => :helper do
  include ApplicationHelper

  describe 'showing_both?' do
    it "returns true if filter all" do
      allow(self).to receive_messages(params: {filter: 'all'})
      expect(showing_both?).to be true
    end

    it "returns true if minimum races completed" do
      assign(:season, Season.new(2010))
      allow(self).to receive_messages(params: {}, completed_min_races?: true, season_completed?: false)
      expect(showing_both?).to be true
    end

    it "should be able to call season_completed?" do
      pending
      assert season_completed?
    end
  end
end