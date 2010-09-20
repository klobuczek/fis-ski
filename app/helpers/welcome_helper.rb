module WelcomeHelper
  def age_class season, gender, age_class
    klass = AgeClass.new :season => season.to_i, :age_class => age_class.to_i
    "#{klass.age_group gender}#{age_class} (#{klass.min_age}-#{klass.max_age})"
  end
end
