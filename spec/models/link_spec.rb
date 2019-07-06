require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('http://foo.com').for(:url) }
  it { should_not allow_value('foo.com').for(:url) }

  let!(:question) { create(:question) }
  let(:gist_link) { create(:link, url: 'https://gist.github.com/histfak/ba9a3358cbe5e99563b7a56b5ae0dc4a', linkable: question) }
  let(:regular_link) { create(:link, url: 'http:/google.com', linkable: question) }

  it 'returns gist content' do
    expect(gist_link.gist_fetch_content).to eq('Hello, world!')
  end

  it 'has the correct gist check method' do
    expect(gist_link).to be_gist
    expect(regular_link).not_to be_gist
  end
end
