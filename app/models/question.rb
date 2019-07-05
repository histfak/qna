class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
end
