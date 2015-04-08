# @category age category number

class AgeClass
  AGE_GROUPS = ('A'..'C').to_a

  attr_reader :age_group

  def initialize options
    @season = options[:season] if options[:season]
    @age_group = options[:age_group] if options[:age_group]
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
    year max_age
  end

  def max_year
    year min_age
  end

  def year age
    @season.to_i - 1 - age
  end

  def min_age
    25 + (@age_class || (age_group == 'B' ? 6 : 1))*5
  end

  def max_age
    @age_class ? min_age + 4 : age_group == 'A' ? 54 : 9999
  end

  def == other
    @age_class == other.to_i
  end

  def gender
    ['A','B'].include?(age_group) ? 'M' : 'L'
  end

  def classes
    return [] unless @age_group
    ((@age_group == 'B' ? 6 : 1)..(@age_group == 'A' ? 5 : 13)).to_a
  end
end