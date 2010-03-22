module CompetitorsHelper
  def tie_breaker
    @tie_breaker ||= (@competitors.inject(false) {|r,c| r ||= c.tie} and params[:filter] == 'qualified')
  end
  
  def season
    params[:season] ? Season.new(params[:season].to_i) : Season.current
  end

  def pass_params filter
    {:gender => params[:gender], :category => params[:category], :season => season, :filter => filter}
  end
end
