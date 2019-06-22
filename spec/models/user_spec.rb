require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:question) { user.questions.create }

  it 'has the correct author check method' do
    expect(user).to be_author(question)
  end
end
