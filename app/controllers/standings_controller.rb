class StandingsController < ApplicationController
  def index
    @competitors = FisParser.new.parse params[:gender], params[:category].to_i

    #File.open("log/competitors.yml", "w") {|f| YAML.dump(@competitors, f)}
    #@competitors = YAML.load_file("log/competitors.yml")
  end
end
