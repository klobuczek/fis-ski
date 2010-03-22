class RacesController < ApplicationController
  def index
    @races = Race.all(:conditions => {:season => season.to_i})
  end
end
