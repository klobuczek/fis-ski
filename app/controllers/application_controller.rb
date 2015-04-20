class ApplicationController < ActionController::Base
  include ApplicationHelper
  # include all helpers, all the time
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  layout 'layout'

  helper :application
  helper_method :season

  def default_url_options(options={})
    params.slice(:rule)
  end

  def season
    @season ||= (params[:season] ? Season.new(params[:season].to_i) : Season.current)
  end
end
