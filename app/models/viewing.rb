class Viewing < ApplicationRecord
  belongs_to :room
  belongs_to :video
  has_many :joinings, dependent: :destroy
  has_many :users, through: :joinings
end
