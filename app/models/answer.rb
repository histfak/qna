class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best: :desc, updated_at: :desc) }

  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.reward.update!(user: author) if question.reward.present? && !question.author.author?(self)
    end
  end
end
