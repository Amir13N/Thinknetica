# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = FindForOauthService.new(auth).call

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    @user = FindForOauthService.new(auth).call

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    elsif auth[:info][:email].nil?
      session[:auth] = { provider: auth[:provider], uid: auth[:uid] }
      redirect_to email_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def send_email_confirmation_message
    FindForOauthService.new(session[:auth].symbolize_keys.merge({ info: { email: params[:email] } })).call
    session.delete(:auth)
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
