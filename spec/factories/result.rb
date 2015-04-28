FactoryGirl.define do
  factory :result do
    race_points 0
    competitor
    race
    time 1.0
    rule Rule.new
  end
end