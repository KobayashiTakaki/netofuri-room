class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  validates :content, length: { in: 1..150 }

  scope :time_from, ->(time) { where("time >= ?", time) }
  scope :time_to, ->(time) { where("time <= ?", time) }
end
