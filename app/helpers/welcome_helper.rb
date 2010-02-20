module WelcomeHelper
  def age_category gender, category
    start=25+category*5
    "#{gender=='M' ? category < 6 ? 'A' : 'B' : 'C'}#{category} (#{start}-#{start+4})"
  end
end
