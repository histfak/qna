require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:old_questions) { create_list(:question, 3, author: user, created_at: 5.days.ago) }
    let(:yesterday_questions) { create_list(:question, 3, author: user, created_at: 1.days.ago) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with new questions" do
      yesterday_questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end

      old_questions.each do |question|
        expect(mail.body.encoded).not_to match(question.title)
      end
    end
  end
end
