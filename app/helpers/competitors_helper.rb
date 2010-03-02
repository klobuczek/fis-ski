module CompetitorsHelper
  def tie_breaker
    @tie_breaker = (@competitors.inject(false) {|r,c| r ||= c.tie} and params[:qualified] == 'true') if @tie_breaker.nil?
    @tie_breaker
  end
end
