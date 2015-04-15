module ResultHelper
  def details result
    "#{result.race.place} - #{result.race.discipline}#{", #{result.cup_points} pts, #{result.fis_points} FIS points" if result.time}"
  end

  def considered result_counter, result
    result_counter < season.max_races and result.successful?
  end
end