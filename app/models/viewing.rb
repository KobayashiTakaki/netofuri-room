class Viewing < ApplicationRecord
  belongs_to :room
  belongs_to :scene
  has_many :joinings, dependent: :destroy
  has_many :users, through: :joinings

  scope :latest, -> { order(end_time: :desc).first }
  scope :active_at, ->(time) {
    where("? between start_time and end_time", time)
  }

end
