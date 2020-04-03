class Answer < ApplicationRecord
  include Linkable
  include Fileable
  include Authorable
  include Votable
  include Commentable

  belongs_to :question, touch: true

  validates :body, presence: true

  after_create :do_question_subscription_job

  default_scope { order(best: :desc, updated_at: :desc) }

  def set_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.reward.update!(user: author) if question.reward.present? && !question.author.author_of?(self)
    end
  end

  private

  def do_question_subscription_job
    QuestionSubscriptionJob.perform_later(self)
  end
end
