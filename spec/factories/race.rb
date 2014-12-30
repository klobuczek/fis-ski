FactoryGirl.define do
  factory :race do |r|
    r.codex 0
    r.season 2010
    r.place 'Bischofswiesen'
    r.nation 'GER'
    r.gender 'M'
    r.date '30.01.2010'
    r.category 'FMC'
  end
end