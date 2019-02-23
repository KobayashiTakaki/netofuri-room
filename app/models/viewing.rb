class Viewing < ApplicationRecord
  belongs_to :room
  belongs_to :video
  has_many :joinings
  has_many :users, through: :joinings
end
