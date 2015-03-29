module Rules
  class CupPointsRule
    RULE15 = [25, 20, 15, 12]
    RULE30 = [100, 80, 60, 50, 45, 40, 36, 32, 29, 26, 24, 22, 20, 18, 16]
    attr_accessor :points

    def initialize(rule)
      self.points = rule.try(:to_i) == 30 ? RULE30 : RULE15
    end

    def cup_points rank
      rank ? points[rank - 1] || [points.last - (rank - points.length), 0].max : 0
    end
  end
end