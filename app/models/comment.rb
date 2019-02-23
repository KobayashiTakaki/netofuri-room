class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :viewing

  validates :content, length: { in: 1..150 }
end
