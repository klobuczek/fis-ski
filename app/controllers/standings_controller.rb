class StandingsController < ApplicationController
  def index
    params[:age_class]||=1
    params[:age_group]||='A'
    discipline = params[:discipline] == 'All' ? nil : params[:discipline]
    @competitors = Competitor.classify!(
        Result.group_by_competitor(season.to_i, params[:age_group],
                                   params[:age_class] == 'All' ? nil : params[:age_class].to_i, discipline, rule),
        rule, remaining_races, params[:filter], discipline)
  end

  def rule
    @rule ||= Rule.new(params[:rule] || {cup_points_rule: season.to_i <= 2015 ? 15 : 30})
  end
end
