require "rails_helper"

RSpec.describe OauthCallbacksMailer, type: :mailer do
  describe '#confirm_email' do
    let(:mail) { OauthCallbacksMailer.confirm_email('test@mail.ru', { info: { email: '' } }).deliver }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Email confirmation'
    end

    it "render reciever's email" do
      expect(mail.to).to eq ['test@mail.ru']
    end
  end
end
