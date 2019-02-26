class Video < ApplicationRecord
  belongs_to :video_set
  has_many :comments, dependent: :destroy
end
