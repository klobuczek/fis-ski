class CompetitorsController < ApplicationController
  def index
    params[:filter] ||= 'contention'
    @competitors = Competitor.classify!(Result.group_by_competitor(season.to_i, params[:gender], params[:age_class].to_i), rule, remaining_races, params[:filter])
  end

  def rule
    @rule ||= Rule.new(params[:rule])
  end
end
