class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_one :joining, dependent: :destroy

  has_secure_password
  validates :name, presence: true, uniqueness: true, length: { in: 1..50 }
  validates :display_name, length: { maximum: 75 }
end
