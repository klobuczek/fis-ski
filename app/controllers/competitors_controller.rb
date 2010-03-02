class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.classify! Competitor.all(:conditions => {:gender => params[:gender], :category => params[:category].to_i}, :include => :results), params[:qualified] == "true"
  end
end
