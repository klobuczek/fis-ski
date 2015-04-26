class ResultsController < ApplicationController
  def index
    @race = Race.find(params[:race_id])
    @results = Result.add_ranks @race.starts
  end
end