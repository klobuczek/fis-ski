class CronController < ApplicationController
  def index
    FisParser.parse_events    
  end
end
