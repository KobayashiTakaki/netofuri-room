class User < ApplicationRecord
  has_one :room

  has_secure_password
  validates :name, presence: true, uniqueness: true, length: { in: 1..50 }
  validates :display_name, length: { maximum: 75 }
end
