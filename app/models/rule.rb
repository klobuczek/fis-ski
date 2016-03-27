class Rule
  include ActiveAttr::Model
  attribute :cup_points_rule, default: 15
  attribute :handicap, type: Float, default: 0.4
  attribute :min, type: Integer
  attribute :max, type: Integer
  attr_reader :cup_points_rule_instance

  delegate :cup_points, to: :cup_points_rule_instance

  def initialize(attr={})
    super(attr)
    @cup_points_rule_instance = Rules::CupPointsRule.new cup_points_rule
  end

  def max_races season, discipline
    max ||
        case discipline
          when 'Super G'
            4
          when 'Giant Slalom'
            7
          when 'Slalom'
            7
          else
            augment_season(season).max_races
        end
  end


  def min_races season, discipline
    min || (discipline && discipline != 'All' ? 0 : augment_season(season).min_races)
  end

  def augment_season season
    season.is_a?(Season) ? season : season ? Season.new(Season) : Season.current
  end
end
