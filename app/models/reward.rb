class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  validates :title, presence: true

  has_one_attached :badge
end
