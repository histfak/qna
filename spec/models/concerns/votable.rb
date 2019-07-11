require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }

  before { @resource = create(model.to_s.underscore.to_sym) }

  it 'have the correct scores method' do
    expect(@resource.scores).to be_equal 0
    create_list(:vote, 3, votable: @resource)
    expect(@resource.scores).to be_equal 3
  end
end
