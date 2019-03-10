class Scene < ApplicationRecord
  belongs_to :room, dependent: :destroy
  belongs_to :video
  has_many :comments, dependent: :destroy
end
