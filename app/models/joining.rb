class Joining < ApplicationRecord
  belongs_to :user
  belongs_to :viewing, counter_cache: true
end
