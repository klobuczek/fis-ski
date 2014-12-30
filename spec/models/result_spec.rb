describe Result, type: :model do
  describe '#cup_points' do
    [[1, 1, 25], [2, 1, 20], [3, 1, 15], [4, 1, 12], [17, 1, 0], [1, 2, 50]].each do |rank, factor, cup_points|
      it "returns #{cup_points} for rank #{rank}" do
        result = Result.new(:rank => rank)
        allow(result).to receive(:race) { double(:factor => factor) }
        expect(result.cup_points).to eq(cup_points)
      end
    end
    it "should calculate points only once" do
      result = Result.new(:rank => 1)
      allow(result).to receive(:race) { double(:factor => 1) }
      2.times { result.cup_points }
    end
  end

  describe "#by_category" do
    it "should empty array for empty results" do
      allow(Result).to receive(:by_age_class) {[]}
      expect(Result.group_by_competitor(2010, 'M', 4)).to eq([])
    end

    it "should group results by competitors" do
      allow(Result).to receive(:by_age_class).and_return [r1=competitor_stub(1), r2=competitor_stub(1)]
      expect(Result.group_by_competitor(2010, 'M', 4).first.results).to include(r1, r2)
    end

    it "should return nothing" do
      expect(Result.send(:by_age_class, 2010, 'M', 4)).to be_empty
    end

    it "should return result`" do
      result = create(:result)
      expect(Result.send(:by_age_class, 2010, 'M', 4)).to eq([result])
    end
  end

  describe "#sort!" do
    it "should sort correctly" do
      expect([r1 = build(:result, :rank => nil, :fis_points => nil), r2 = build(:result, :rank => 20, :fis_points => 100)].sort).to eq([r2, r1])
    end
  end

  def competitor_stub id
    double(:competitor => Competitor.new(:id => id), :competitor_id => id)
  end
end