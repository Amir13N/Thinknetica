require 'rails_helper'

RSpec.describe AnswerNotifyJob, type: :job do
  let(:service) { double('AnswerNotifyService') }
  let(:answer) { create(:answer) }

  before { allow(AnswerNotifyService).to receive(:new).and_return(service) }

  it 'calls DailyDigestService#send_digest' do
    expect(service).to receive(:notify)
    AnswerNotifyJob.perform_now(answer)
  end
end
