class CompetitorsController < ApplicationController
  def index
    params[:filter] ||= 'contention'
    @competitors = Competitor.classify!(Result.group_by_competitor(season.to_i, params[:gender], params[:category].to_i), remaining_races, params[:filter])
  end
end
