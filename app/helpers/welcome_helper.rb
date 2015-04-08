module WelcomeHelper
  def decorate_age_class age_class, season = Season.current, age_group=nil
    if age_class == 'All'
      [age_group, 'Overall'].compact.join ' '
    else
      klass = AgeClass.new :season => season.to_i, :age_class => age_class.to_i
      "#{age_group}#{age_class} (#{klass.min_age}-#{klass.max_age})"
    end
  end
end
