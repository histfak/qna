class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
