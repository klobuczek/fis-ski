class Season
  def self.current
    (Time.now + 4.months).year
  end

  def self.current? season
    season == current
  end

  def self.earliest
    2004
  end

  def initialize season
    @season = season
  end

  def current?
    @season == self.class.current
  end
end