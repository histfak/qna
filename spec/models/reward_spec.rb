require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to :question }

  it { should validate_presence_of :title }

  it 'has the only attached image file' do
    expect(Reward.new.badge).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
