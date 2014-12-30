describe Race, "#pending" do
  it "returns 0 for no races" do
    expect(Race.send(:pending, Season.current, 'L')).to eq(0)
  end

  it "returns 1 for non completed race" do
    create :race
    expect(Race.send(:pending, 2010, 'M')).to eq(1)
  end
end

describe Race, "#completed" do
  it "returns 0 for no races" do
    expect(Race.send(:scored, 2010, 'A')).to eq(0)
  end

  it "returns 1 for completed race" do
    create :race, :status => Race::LOADED,  :age_group => 'A'
    expect(Race.send(:scored, 2010, 'A')).to eq(1)
  end
end

describe Race, "#remaining" do
  [0, 1].each do |n|
    it "returns #{n} for #{0} races" do
      allow(Race).to receive(:pending) {n}
      expect(Race.remaining('L')).to eq(n)
    end
  end

  it "returns 1 for 2 pending 'A' races" do
    allow(Race).to receive(:pending) {2}
    expect(Race.remaining('M', 3)).to eq(1)
  end

  it "returns 1 for 3 pending 'M', 3 completed 'A' and 2 completed 'B' races" do
    allow(Race).to receive(:pending) {3}
    allow(Race).to receive(:scored).and_return(3, 2)
    expect(Race.remaining('M', 3)).to eq(1)
  end
end

describe Race, "#results" do
  it "returns successful results" do
    create :result
    expect(Race.first.results.count).to eq(1)
  end

  it "returns no successful results" do
    create :result, :overall_rank => nil, :failure => 'DSQ'
    expect(Race.first.results.count).to eq(0)
  end
end

describe Race, "#update_factors" do
  before :each do
    @date = Date.parse '10.03.2010'
    @fmc = create :race, :category => 'FMC', :date => @date
  end

  it "for last FMC race of WMC" do
    wmc = create :race, :category => 'WMC', :date => @date - 1.day
    Race.update_factors 2010
    expect(wmc.reload.factor).to eq(1)
    expect(@fmc.reload.factor).to eq(2)
  end

  it "for single final FMC race" do
    fmc = create :race, :category => 'FMC', :date => @date - 2.days
    Race.update_factors 2010
    expect(fmc.reload.factor).to eq(1)
    expect(@fmc.reload.factor).to eq(2)
  end

  it "for 2 final FMC races" do
    fmc = create :race, :category => 'FMC', :date => @date - 1.day
    Race.update_factors 2010
    expect(fmc.reload.factor).to eq(2)
    expect(@fmc.reload.factor).to eq(2)
  end
end
