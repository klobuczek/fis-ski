# @category age category number

  class Category
  def initialize options
    @season = options[:season] if options[:season]
    @age_category = (@season.to_i - 26 - options[:year])/5 if options[:year]
    @age_category = options[:category].to_i if options[:category]
  end

  def to_i
    @age_category
  end

  def to_s
    @age_category.to_s
  end

  def min_year
    max_year - 4
  end

  def max_year
    @season.to_i - 1 - min_age
  end

  def min_age
    25 + @age_category*5
  end

  def max_age
    min_age + 4
  end

  def race_category gender
    gender == 'M' ? @age_category <= 5 ? 'A' : 'B' : 'C'
  end

  def == other
    @age_category == other.to_i
  end

  def self.same? season, year1, year2
    Category.new(:season=> season, :year => year1) == Category.new(:season=> season, :year => year2)
  end
end