require 'rails_helper'

RSpec.shared_examples_for 'fileable' do
  let!(:model) { described_class }
  before { @resource = create(model.to_s.underscore.to_sym, :with_files) }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'has a correct files_params method' do
    expect(@resource.files_params).to be_a(Array)
    expect(@resource.files_params.first.key?(:name)).to be_truthy
    expect(@resource.files_params.first.key?(:url)).to be_truthy
  end
end
