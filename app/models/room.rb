class Room < ApplicationRecord
  has_one :video_set
  has_many :viewings

  def active_viewing
    viewings.active
  end
end
