  class Category
  def initialize options
    @season = options[:season] if options[:season]
    @cat = (@season.to_i - 26 - options[:year])/5 if options[:year]
    @cat = options[:category] if options[:category]
  end

  def to_i
    @cat
  end

  def to_s
    @cat.to_s
  end

  def min_year
    max_year - 4
  end

  def max_year
    @season.to_i - 1 - min_age
  end

  def min_age
    25 + @cat*5
  end

  def max_age
    min_age + 4
  end

  def race_category gender
    gender == 'M' ? @cat <= 5 ? 'A' : 'B' : 'C'
  end

  def == other
    @cat == other.to_i
  end

  def self.same? season, year1, year2
    Category.new(:season=> season, :year => year1) == Category.new(:season=> season, :year => year2)
  end
end