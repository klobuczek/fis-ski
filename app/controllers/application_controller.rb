class ApplicationController < ActionController::Base
  helper :all
  # include all helpers, all the time
  protect_from_forgery
  # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  layout 'layout'

  helper_method :season, :season_completed?, :remaining_races

  def season
    @season ||= (params[:season] ? Season.new(params[:season].to_i) : Season.current)
  end

  def season_completed?
    remaining_races == 0
  end

  def remaining_races
    season.current? ? Race.remaining(params[:gender], params[:age_class].to_i) : 0
  end
end
