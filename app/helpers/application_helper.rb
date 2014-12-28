module ApplicationHelper
  def season
    @season ||= (params[:season] ? Season.new(params[:season].to_i) : Season.current)
  end

  def season_completed?
    remaining_races == 0 and season.advanced?
  end

  def remaining_races
    season.current? ? Race.remaining(params[:gender], params[:age_class].to_i) : 0
  end
end
