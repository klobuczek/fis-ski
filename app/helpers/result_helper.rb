module ResultHelper
  def details result
    "#{result.race.place} - #{result.race.discipline}#{", #{result.cup_points} pts, #{result.race_points} FIS points" if result.time}"
  end

  def considered result_counter, result
    result_counter < @rule.max_races(season, result.discipline) and result.successful?
  end
end