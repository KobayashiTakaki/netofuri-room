class VideoSet < ApplicationRecord
  has_many :videos, dependent: :destroy
end
