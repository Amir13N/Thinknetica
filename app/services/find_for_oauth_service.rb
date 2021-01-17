# frozen_string_literal: true

class FindForOauthService
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: @auth[:provider], uid: @auth[:uid].to_s)
    if authorization
      return authorization.user
    elsif @auth[:info][:email].nil?
      return
    end

    email = @auth[:info][:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization(@auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(@auth)
    end

    user
  end
end
