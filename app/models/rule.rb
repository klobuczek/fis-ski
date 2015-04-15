class Rule
  include ActiveAttr::Model
  attribute :cup_points_rule
  attribute :handicap, type: Float
  attr_reader :cup_points_rule_instance

  delegate :cup_points, to: :cup_points_rule_instance

  def initialize(attr={})
    super
    @cup_points_rule_instance = Rules::CupPointsRule.new cup_points_rule
  end

end
