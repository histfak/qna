require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  before { @resource = create(model.to_s.underscore.to_sym) }

  let!(:model) { described_class }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:vote) { @resource.votes.create(user: user2) }

  it 'have the correct scores method' do
    expect(@resource.scores).to be_equal 0
    create_list(:vote, 3, votable: @resource)
    expect(@resource.scores).to be_equal 3
  end

  it 'have the correct scores method' do
    expect(@resource.scores).to be_equal 0
    create_list(:vote, 3, votable: @resource)
    expect(@resource.scores).to be_equal 3
  end

  it 'have the correct voted? method' do
    expect(@resource).not_to be_voted(user)
    expect(@resource).to be_voted(user2)
  end

  it 'have the correct new_like method' do
    @resource.new_like(user)
    expect(@resource.votes.last.score).to eq 1
  end

  it 'have the correct new_dislike method' do
    @resource.new_dislike(user)
    expect(@resource.votes.last.score).to eq -1
  end
end
