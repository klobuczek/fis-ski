class RacesController < ApplicationController
  def index
    @races = Race.all(:conditions => {:season => season.to_i}, :order => :date)
  end
end
