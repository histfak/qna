require "rails_helper"

RSpec.describe QuestionSubscriptionMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { QuestionSubscriptionMailer.question_subscription(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Question subscription")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with question title and a new answer" do
      expect(mail.body.encoded).to match(answer.question.title)
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
