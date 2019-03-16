class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :scene
  validates :content, length: { in: 1..150 }
  validates :time, presence: true

  scope :order_by_time, -> { order(:time) }
  scope :time_from, ->(time) { where("time >= ?", time) }
  scope :time_to, ->(time) { where("time <= ?", time) }
  scope :by_scene, ->(scene) { joins(:scene).where(scene: scene) }

  def to_hash
    {
      id: id,
      time: time,
      user_id: user.id,
      username: user.display_name || user.name,
      content: content
    }
  end
end
