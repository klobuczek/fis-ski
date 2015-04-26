class StandingsController < ApplicationController
  def index
    # redirect_to welcomes_url unless params[:age_class]
    @competitors = Competitor.classify!(
        Result.group_by_competitor(season.to_i, params[:age_group],
                                   params[:age_class] == 'All' ? nil : params[:age_class].to_i,
                                   params[:discipline] == 'All' ? nil : params[:discipline]),
        rule, remaining_races, params[:filter])
  end

  def rule
    @rule ||= Rule.new(params[:rule])
  end
end
