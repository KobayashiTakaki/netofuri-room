class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :content, length: { in: 1..150 }
end
