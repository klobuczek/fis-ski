module CompetitorsHelper
  def tie_breaker
    @tie_breaker ||= (@competitors.inject(false) {|r, c| r ||= c.tie} and (params[:filter] == 'qualified' or (params[:filter] == 'contention' and season_completed?)))
  end

  def pass_params filter
    {:gender => params[:gender], :category => params[:category], :season => season, :filter => filter}
  end

  def elimination_phase?
    remaining_races < season.min_races
  end

  def showing_both?
    params[:filter] == 'all' or (completed_min_races and !season_completed?)
  end
                        
  private
  def completed_min_races
    Race.completed_races_count(season, params[:gender], params[:category]) >= season.min_races
  end
end
