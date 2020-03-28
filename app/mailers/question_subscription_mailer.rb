class QuestionSubscriptionMailer < ApplicationMailer
  def question_subscription(user, answer)
    @answer = answer

    mail to: user.email
  end
end
