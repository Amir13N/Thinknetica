# frozen_string_literal: true

class OauthCallbacksMailer < ApplicationMailer
  def confirm_email(email, auth)
    @auth = auth
    @auth[:info] = { email: email }
    mail to: email, subject: 'Email confirmation'
  end
end
