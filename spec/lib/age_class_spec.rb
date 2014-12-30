describe AgeClass, "#age_group" do
  it "returns A for no M3 results" do
    expect(AgeClass.new(:age_class => '3').age_group('M')).to eq('A')
  end
end