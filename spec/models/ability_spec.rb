require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question }
    let(:answer) { create :answer }
    let(:user_question) { create :question, author: user }
    let!(:answer2) { create :answer, question: user_question }
    let(:user_answer) { create :answer, author: user }
    let(:question_with_files) { create :question, :with_files }
    let(:user_question_with_files) { create :question, :with_files, author: user }
    let(:answer_with_files) { create :answer, :with_files }
    let(:user_answer_with_files) { create :answer, :with_files, author: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create_comment, Question }
    it { should be_able_to :create_comment, Answer }

    it { should be_able_to [:update, :destroy], user_question }
    it { should_not be_able_to [:update, :destroy], question }

    it { should be_able_to [:update, :destroy], user_answer }
    it { should_not be_able_to [:update, :destroy], answer }

    it { should be_able_to :destroy, create(:link, linkable: user_question) }
    it { should be_able_to :destroy, create(:link, linkable: user_answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: answer) }

    it { should be_able_to :destroy, user_question_with_files.files.first }
    it { should be_able_to :destroy, user_answer_with_files.files.first }
    it { should_not be_able_to :destroy, question_with_files.files.first }
    it { should_not be_able_to :destroy, answer_with_files.files.first }

    it { should be_able_to :best, user_question.answers.first }
    it { should_not be_able_to :best, question.answers.first }

    it { should be_able_to [:like, :dislike, :reset], question }
    it { should be_able_to [:like, :dislike, :reset], answer }

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, create(:subscription, user: user) }
    it { should_not be_able_to :destroy, create(:subscription) }
  end
end
