class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc, updated_at: :desc) }

  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
