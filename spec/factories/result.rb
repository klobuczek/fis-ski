FactoryGirl.define do
  factory :result do |r|
    r.race_points 0
    r.association :competitor
    r.association :race
    r.time 1.0
    r.rule Rule.new
  end
end