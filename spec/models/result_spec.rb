describe Result, type: :model do
  describe '#cup_points' do
    [[1, 1, 25], [2, 1, 20], [3, 1, 15], [4, 1, 12], [17, 1, 0], [1, 2, 50]].each do |rank, factor, cup_points|
      it "returns #{cup_points} for rank #{rank}" do
        result = create(:result, :rank => rank)
        allow(result).to receive(:race) { double(:factor => factor) }
        expect(result.cup_points).to eq(cup_points)
      end
    end
    it "should calculate points only once" do
      result = create(:result, rank: 1)
      allow(result).to receive(:race) { double(:factor => 1) }
      2.times { result.cup_points }
    end
  end

  describe "#by_category" do
    it "should empty array for empty results" do
      allow(Result).to receive(:by_age_class) { [] }
      expect(Result.group_by_competitor(2010, 'A', 4, 'dummy')).to eq([])
    end

    it "should group results by competitors" do
      c = create :competitor
      r1 = create :result, competitor: c
      r2 = create :result, competitor: c
      expect(Result.group_by_competitor(2010, 'A', 4, nil).first.results).to include(r1, r2)
    end

    it "should return nothing" do
      expect(Result.send(:by_age_class, 2010, 'A', 4, 'Slalom')).to be_empty
    end

    it "should return result`" do
      result = create(:result)
      expect(Result.send(:by_age_class, 2010, 'A', 4, 'Slalom')).to eq([result])
    end
  end

  describe "#sort!" do
    it "should sort correctly" do
      expect([r1 = build(:result, :rank => nil, :fis_points => nil), r2 = build(:result, :rank => 20, :fis_points => 100)].sort).to eq([r2, r1])
    end
  end

  describe "#add_rank" do
    it "should inject rank" do
      {[1.0, 2.0, nil] => [1, 2, nil],
       [1.0, 1.0, 1.0, 2.0] => [1, 1, 1, 4]}.each do |times, ranks|
        expect(Result.send(:add_ranks, times.map { |time| create :result, time: time }).map(&:rank)).to eq(ranks)
      end
    end
  end

  def competitor_stub id
    double(:competitor => Competitor.new(:id => id), :competitor_id => id, race_id: 123, time: 1.0)
  end
end