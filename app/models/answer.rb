class Answer < ApplicationRecord
  include Linkable
  include Fileable
  include Authorable
  include Votable

  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc, updated_at: :desc) }

  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.reward.update!(user: author) if question.reward.present? && !question.author.author_of?(self)
    end
  end
end
