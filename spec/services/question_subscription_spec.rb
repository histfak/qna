require 'rails_helper'

RSpec.describe Services::QuestionSubscription do
  let(:question) { create(:question) }
  let!(:subscription) { create_list(:subscription, 3, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends a new answer to the subscribed' do
    subscription.each { |s| expect(QuestionSubscriptionMailer).to receive(:question_subscription).with(s.user, answer).and_call_original }
    subject.send_update(answer)
  end
end
