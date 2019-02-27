class Room < ApplicationRecord
  has_one :video_set
  has_many :viewings
end
