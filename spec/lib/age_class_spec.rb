describe AgeClass, "#age_group" do
  it "returns overall years" do
    age_class = AgeClass.new season: 2015, age_group: 'A', age_class: 5
    expect(age_class.min_year).to eq(1960)
    expect(age_class.max_year).to eq(1964)
  end
end