class RacesController < ApplicationController
  def index
    @races = Race.where(default_params.merge race_params).order("date, codex")
  end

  def race_params
    params.permit(:season, :age_group, (:discipline unless params[:discipline] == 'All'))
  end

  private
  def default_params
    {season: season.to_i}
  end
end
