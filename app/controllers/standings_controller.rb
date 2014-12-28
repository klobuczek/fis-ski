class StandingsController < ApplicationController
  def index
    params[:filter] ||= 'contention'
    @competitors = Competitor.classify!(Result.group_by_competitor(season.to_i, params[:gender], params[:age_class].to_i), remaining_races, params[:filter])
  end
end
