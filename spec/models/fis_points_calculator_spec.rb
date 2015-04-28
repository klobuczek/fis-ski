def load_results(race, results)
  previous_races = [1, 2].map { |_| create :race, discipline: race.discipline, season: race.season - 1, penalty: 0.0 }
  race_points = 0.0
  results.map do |result|
    fis_points = result[2]
    if result.first.is_a?(Symbol)
      failure = result.first
    else
      time = result.first
    end
    race_points = result[3] || race_points + 0.01
    competitor = create :competitor, name: result[1], fis_points: fis_points
    previous_races.each do |r|
      create :result, race: r, competitor: competitor, race_points: fis_points, time: fis_points
    end if fis_points
    create :result, race: race, rank: nil, time: time, race_points: (race_points unless failure),
           competitor: competitor, failure: failure
  end
end

describe FisPointsCalculator do
  describe Race, "#calculate_penalty" do
    [
        {discipline: 'Giant Slalom',
         results: [
             [1, 3, 20.97, 0.00],
             [2, 13, 25.42],
             [3, 6, 30.31],
             [4, 10, 20.78, 5.35],
             [5, 9, 23.83, 6.44],
             [6, 11, 22.64, 7.59],
             [7, 14, 24.37],
             [8, 15, 9.45, 10.03],
             [9, 1, 26.81],
             [10, 8, 28.52],
             [:DNF, 4, 16.64],
             [:DSQ, 2, 17.58],
             [14, 7, 19.80],
         ],
         penalty: 15.25
        },
        {discipline: 'Downhill',
         results: [
             [1, 2],
             [2, 10, 28.00, 10.12],
             [3, 1],
             [4, 3, 149.00, 17.00],
             [5, 15, 70.00, 20.40],
             [6, 4],
             [7, 5],
             [8, 18, 425.00, 75.00],
             [9, 20],
             [10, 28, nil, 82.00],
             # [:DNF, 15, 70.00],
             [:DNF, 6, 125.00],
             # [:DNF, 3, 149.00],
         ],
         penalty: 134.45
        },
        {discipline: 'Slalom',
         results: [
             [1, 4, 25.75, 0.00],
             [2, 11, 48.16, 10.00],
             [3, 5, 175.11, 20.00],
             [4, 3, nil, 185.00],
             [5, 8, nil, 205.00],
             [6, 15, nil, 270.00],
             [7, 2, nil, 300.00],
             [8, 10, nil, 301.00],
             [9, 32, nil, 302],
             [10, 38, nil, 303],
         ],
         penalty: 69.78
        },
        {discipline: 'Super G',
         results: [
             [1, 3, 20.97, 0.00],
             [2, 13, 25.42],
             [3, 6, 30.31],
             [4, 10, 20.78, 5.35],
             [5, 9, 23.83, 6.44],
             [6, 11, 22.64, 7.59],
             [7, 14, 24.37],
             [8, 15, 9.45, 10.03],
             [9, 1, 26.81],
             [10, 8, 28.52],
             [:DNF, 4, 16.64],
             [:DSQ, 2, 17.58],
             [14, 7, 19.80],
         ],
         penalty: 15.25
        },
        {discipline: 'Downhill',
         results: [
             [1, 2],
             [2, 10, 28.00, 10.12],
             [3, 1],
             [4, 3, 149.00, 17.00],
             [5, 15, 70.00, 20.40],
             [6, 4],
             [7, 5],
             [8, 18],
             [9, 20, nil, 80.00],
             [10, 28, nil, 82.00],
             [:DNF, 6, 125.00],
         ],
         penalty: 133.95
        },
    ].each do |desc|
      it desc[:discipline] do
        race = create :race, desc.slice(:discipline)
        load_results(race, desc[:results])
        expect(race.calculate_penalty).to eq(desc[:penalty])
      end
    end
  end
end
