require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'fileable'
  it_behaves_like 'authorable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward }

  describe '.past_day' do
    let(:old_questions) { create_list(:question, 3, created_at: 5.day.ago) }
    let(:yesterday_questions) { create_list(:question, 3, created_at: 1.day.ago) }

    it { expect(Question.past_day).to eq yesterday_questions }
    it { expect(Question.past_day).not_to eq old_questions }
  end

  describe '#subscription' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2) }
    let!(:subscription) { create(:subscription, question: questions.first, user: user) }

    it 'returns subscription for subscribed question' do
      expect(questions.first.subscription(user)).to eq subscription
    end

    it 'returns nil for not subscribed question' do
      expect(questions.second.subscription(user)).to eq nil
    end
  end

  describe '#subscribe!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'not subscribed yet' do
      it 'subscribes user' do
        expect { question.subscribe!(user) }.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'does not subscribe user' do
        expect { question.subscribe!(user) }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe '#unsubscribe!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'unsubscribes user' do
        expect { question.unsubscribe!(user) }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'not subscribed' do
      it 'does not unsubscribe user' do
        expect { question.unsubscribe!(user) }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
