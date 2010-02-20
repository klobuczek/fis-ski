class StandingsController < ApplicationController
  def index
    @competitors = FisParser.new.parse params[:gender], params[:category].to_i
  end
end
