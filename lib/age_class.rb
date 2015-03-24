# @category age category number

class AgeClass
  def initialize options
    @season = options[:season] if options[:season]
    @age_class = (@season.to_i - 26 - options[:year])/5 if options[:year]
    @age_class = options[:age_class].to_i if options[:age_class]
  end

  def to_i
    @age_class
  end

  def to_s
    @age_class.to_s
  end

  def min_year
    max_year - 4
  end

  def max_year
    @season.to_i - 1 - min_age
  end

  def min_age
    25 + @age_class*5
  end

  def max_age
    min_age + 4
  end

  def age_group gender
    gender == 'M' ? @age_class <= 5 ? 'A' : 'B' : 'C'
  end

  def == other
    @age_class == other.to_i
  end
end