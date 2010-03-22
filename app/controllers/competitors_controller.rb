class CompetitorsController < ApplicationController
  def index
    params[:filter] ||= 'qualified' unless season.current?
    @competitors = Competitor.classify! Result.for(season.to_i, params[:gender], params[:category].to_i).group_by_competitor, params[:filter]
  end
end
