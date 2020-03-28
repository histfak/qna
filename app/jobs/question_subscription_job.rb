class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::QuestionSubscription.new.send_update(answer)
  end
end
