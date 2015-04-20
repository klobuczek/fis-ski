class ResultsController < ApplicationController
  def index
    @race = Race.find(params[:race_id])
    @results = Result.add_ranks Result.started.where(result_params).includes(:competitor).order("-time desc, failure desc")
  end

  def result_params
    params.permit(:race_id)
  end
end