module ApplicationHelper
  def season
    @season ||= (params[:season] ? Season.new(params[:season].to_i) : Season.current)
  end

  def season_completed?
    remaining_races == 0 and season.advanced?
  end

  def remaining_races
    season.current? ? Race.remaining(params[:age_group], params[:age_class].to_i) : 0
  end

  def rewrite_params options={}
    {season: Season.current.to_i, age_group: :A, filter: :contention, discipline: :All}.with_indifferent_access.merge(params.except :controller, :action).merge(options)
  end

  def highlighted_link key, value
    rewritten_params = rewrite_params(key => value)
    link_to block_given? ? yield(value) : value, send(rewritten_params[:age_class] ? :competitors_url : :root_url, rewritten_params), class: ('bg-primary' if value.to_s == params[key].to_s)
  end
end
