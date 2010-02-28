class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.classify! Competitor.find_all_by_gender_and_category(params[:gender], params[:category].to_i), params[:qualified] == "true"
  end
end
