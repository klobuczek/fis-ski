FactoryGirl.define do
  factory :result do |r|
    r.fis_points 0
    r.overall_rank 1
    r.association :competitor
    r.association :race
  end
end