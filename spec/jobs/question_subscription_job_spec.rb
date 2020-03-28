require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:answer) { create(:answer) }
  let(:service) { double('Services::QuestionSubscription') }

  before do
    allow(Services::QuestionSubscription).to receive(:new).and_return(service)
  end

  it 'calls Services::QuestionSubscription#send_update' do
    expect(service).to receive(:send_update).with(answer)
    QuestionSubscriptionJob.perform_now(answer)
  end
end
