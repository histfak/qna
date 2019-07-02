require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer1) { question.answers.create(body: 'answer1', author: user) }
  let!(:answer2) { question.answers.create(body: 'answer2', author: user) }
  let!(:answer3) { question.answers.create(body: 'answer3', author: user) }

  it { should belong_to :question }
  it { should belong_to(:author).class_name('User') }
  it { should have_db_index :question_id }

  it { should validate_presence_of :body }

  it 'sets the best answer to the question' do
    question.answers.first.set_best
    expect(question.answers.first).to be_best
  end

  it 'sets the only best answer to the question' do
    question.answers.first.set_best
    question.answers.second.set_best
    expect(question.answers.where(best: true).count).to eq 1
  end

  it 'checks that best answer goes first and the rest goes by updated at' do
    question.answers.second.set_best
    expect(question.answers.to_a).to eq([answer2, answer3, answer1])
  end
end
