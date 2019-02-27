class Viewing < ApplicationRecord
  belongs_to :room
  belongs_to :video
  has_many :joinings, dependent: :destroy
  has_many :users, through: :joinings

  scope :for_video_set, ->(video_set) {
    includes(:video).where(video: video_set.videos.ids)
  }
  scope :latest, -> { order(end_time: :desc).first }
  scope :active, -> {
    where("? between start_time and end_time", Time.zone.now).first
  }

end
