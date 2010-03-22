class CompetitorsController < ApplicationController
  helper_method :season

  def season
    params[:season] ? Season.new(params[:season].to_i) : Season.current
  end

  def index
    puts "************#{season.current?}"
    params[:filter] ||= 'qualified' unless season.current?
    @competitors = Competitor.classify! Result.for(season.to_i, params[:gender], params[:category].to_i).group_by_competitor, params[:filter]
  end
end
