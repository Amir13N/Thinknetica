# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: %(Qna <mail@qna.com>)
  layout 'mailer'
end
