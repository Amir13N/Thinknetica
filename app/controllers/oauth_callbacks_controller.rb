# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  include RailsTemporaryData::ControllerHelpers

  def github
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    elsif auth[:info][:email].nil?
      set_tmp_data('auth', auth)
      redirect_to email_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def send_email_confirmation_message
    OauthCallbacksMailer.confirm_email(params[:email], get_tmp_data('auth').data).deliver
  end

  def confirm_email
    User.find_for_oauth(params[:auth])
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
