FactoryBot.define do
  factory :video do
    sequence(:netflix_id) { |n| n }
    sequence(:season) { 1 }
    sequence(:episode) { |n| n }
    runtime { 1400 }
  end
end
