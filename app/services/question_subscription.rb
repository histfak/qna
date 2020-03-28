class Services::QuestionSubscription
  def send_update(answer)
    @users = answer.question.subscribers
    @users.find_each(batch_size: 500) do |user|
      QuestionSubscriptionMailer.question_subscription(user, answer).deliver_later
    end
  end
end
