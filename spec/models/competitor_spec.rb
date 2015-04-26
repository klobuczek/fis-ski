describe Competitor, "#calculate" do
  it "returns 0 for no results" do
    c=Competitor.new
    allow(c).to receive(:results) { [] }
    expect(c.send(:calculate, :any_attr)).to eq(0.0)
  end

  it "sums up points for less than max results" do
    c=Competitor.new
    allow(c).to receive(:results) { (1..3).map { |p| double(:any_attr => p) } }
    allow(c).to receive(:season) { double(:max_races => 4) }
    expect(c.send(:calculate, :any_attr)).to eq(6.0)
  end

  it "sums up points for more than max results" do
    c=Competitor.new
    allow(c).to receive(:results) { (1..6).map { |p| double(:any_attr => p) } }
    allow(c).to receive(:season) { double(:max_races => 4) }
    expect(c.send(:calculate, :any_attr)).to eq(10.0)
  end

  it "should sort correctly" do
    r1 = create(:result, :time => nil, :race_points => nil)
    r2 = create(:result, :time => 20, :race_points => 100)
    r1.competitor.results=[r1, r2]
    r1.competitor.results.sort!
    expect(r1.competitor.results).to eq([r2, r1])
  end
end