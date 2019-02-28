class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  validates :content, length: { in: 1..150 }
  validates :time, presence: true

  scope :order_by_time, -> { order(:time) }
  scope :time_from, ->(time) { where("time >= ?", time) }
  scope :time_to, ->(time) { where("time <= ?", time) }
  scope :by_video, ->(video) { joins(:video).where(video: video) }

  def to_hash
    {
      id: self.id,
      time: self.time,
      user_id: self.user.id,
      username: self.user.name,
      content: self.content
    }
  end
end
