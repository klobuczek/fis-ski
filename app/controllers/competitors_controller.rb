class CompetitorsController < ApplicationController
  def index
    puts "<#{params[:season].to_i.inspect}>"
    @competitors = Competitor.classify! Result.for((params[:season] || Season.current).to_i, params[:gender], params[:category].to_i).group_by_competitor, params[:qualified] == "true"
  end
end
