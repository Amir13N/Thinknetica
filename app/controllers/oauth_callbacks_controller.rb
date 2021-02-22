# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :cors_set_access_control_headers

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
    user = FindForOauthService.new(session[:auth].symbolize_keys.merge({ info: { email: params[:email] } })).call
    session.delete(:auth)
  end

  private

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end

  def auth
    request.env['omniauth.auth']
  end
end
