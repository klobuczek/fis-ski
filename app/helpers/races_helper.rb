module RacesHelper
  def fis_race_href href
     href += "&catage=#{params[:age_class].to_i+5}" if params[:season].to_i >= 2010
     href
  end
end
