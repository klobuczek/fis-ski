FactoryGirl.define do
  factory :competitor do
    gender 'M'
    fis_code 0
    year 1964
    rule Rule.new
  end
end
