FactoryGirl.define do
  factory :competitor do |c|
    c.gender 'M'
    c.fis_code 0
    c.year 1964
    c.rule Rule.new
  end
end
