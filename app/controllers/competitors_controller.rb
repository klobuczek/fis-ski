class CompetitorsController < ApplicationController
  def show
    @competitor = Competitor.find(params[:id])
    @results = @competitor.results.where(races: {discipline: params[:discipline]}).includes(:race).order("races.date desc")
  end
end