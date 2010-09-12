class RacesController < ApplicationController
  def index
    @races = Race.where(:season => season.to_i).order("date, codex")
  end
end
