module CompetitorsHelper
  def tie_breaker
    @tie_breaker ||= (@competitors.inject(false) {|r,c| r ||= c.tie} and params[:filter] == 'qualified')
  end
  
  def season
    params[:season] ? Season.new(params[:season].to_i) : Season.current
  end
end
