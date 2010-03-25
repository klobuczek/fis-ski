module CompetitorsHelper
  def tie_breaker
    @tie_breaker ||= (@competitors.inject(false) {|r, c| r ||= c.tie} and (params[:filter] == 'qualified' or (params[:filter] == 'contention' and season_completed?)))
  end

  def season
    params[:season] ? Season.new(params[:season].to_i) : Season.current
  end

  def pass_params filter
    {:gender => params[:gender], :category => params[:category], :season => season, :filter => filter}
  end

  def elimination_phase?
    remaining_races < season.min_races
  end
end
