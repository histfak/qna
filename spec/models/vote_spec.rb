require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it do
    subject.user = create(:user)
    should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])
  end

  it { should validate_presence_of :score }

  let!(:vote) { create(:vote) }

  it 'has the correct like method' do
    vote.like
    expect(vote.score).to be_equal(1)
  end

  it 'has the correct dislike method' do
    vote.dislike
    expect(vote.score).to be_equal(-1)
  end

  it 'has the correct reset method' do
    vote.reset
    expect { vote.reload }.to raise_error ActiveRecord::RecordNotFound
  end
end
