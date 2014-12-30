require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
    ActiveRecord::Base.transaction { FisParser.load_season Season.current }
  end

  every(1.hour, 'load')
end