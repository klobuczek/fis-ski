module RacesHelper
  def fis_race_href href
     href += "&catage=#{params[:age_class].to_i+5}" if Season.current? params[:season]
     href
  end
end
