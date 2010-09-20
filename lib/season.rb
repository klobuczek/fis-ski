class Season
  def self.current
    Season.new(Time.now)
  end

  def self.current? season
    season.to_i == current.to_i
  end

  def self.earliest
    1999
  end

  def self.fmc_earliest
    2004
  end

  def initialize date
    @season = date.is_a?(Integer) ? date : (date + 4.months).year
  end

  def current?
    @season == self.class.current.to_i
  end

  def min_races
     @season < 2010 ? 5 : 6
  end

  def max_races
     @season < 2010 ? 7 :9
  end

  def to_i
    @season
  end
  
  def to_s
    @season.to_s
  end
end