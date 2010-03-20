module WelcomeHelper
  def age_category season, gender, category 
    cat = Category.new :season => season.to_i, :category => category.to_i
    "#{cat.race_category gender}#{category} (#{cat.min_age}-#{cat.max_age})"
  end
end
