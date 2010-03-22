class CompetitorsController < ApplicationController
  def index
    params[:filter] ||= 'contention'
    @competitors = Competitor.classify! Result.for(season.to_i, params[:gender], params[:category].to_i).group_by_competitor, remaining_races, params[:filter]
  end
end
