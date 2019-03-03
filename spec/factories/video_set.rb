FactoryBot.define do
  factory :video_set do
    sequence(:netflix_id) { |n| n }
    title { "Test Video Set" }
    video_type { "show" }
    room { Room.new }
  end
end
