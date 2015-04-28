class ResultsController < ApplicationController
  def index
    @race = Race.find(params[:race_id])
    @results = @race.complete_results
  end
end