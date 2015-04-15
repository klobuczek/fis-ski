describe FisParser do
  describe ".update_events" do

    it "should not create races if no races found" do
      FisParser.send(:fetch_races, Season.current.to_i, path(:no_races_found))
      Race.count == 0
    end

    it "should record failures" do
      FisParser.send(:fetch_results, create(:race, :href => path(:results_with_failures)))
      expect(Result.where(:failure => 'DSQ').count).to be > 0
    end

    it "should convert integer values" do
      expect(FisParser.send(:i, [Nokogiri::HTML('&nbsp;5200921')], 0)).to eq(5200921)
    end

    it "should record time" do
      FisParser.send(:fetch_results, create(:race, :href => path(:results_with_failures)))
      expect(Result.first.time).to be > 1
    end

    it "should survive missing fis points" do
      race = create(:race, :href => path(:missing_fis_points), season: 2015, discipline: :Slalom)
      FisParser.send(:fetch_results, race)
      expect(race.results.first.time).to eq(97.68)
      expect(race.results.second.fis_points).to eq(34.13)
    end
  end

  describe ".to_time" do
    it "should convert time" do
      expect(FisParser.send :to_time, '1:02.46').to eq(62.46)
      expect(FisParser.send :to_time, '1:02,46').to eq(62.46)
    end
  end
end

def path name
  File.new("#{::Rails.root}/spec/documents/#{name}.html").path
end

