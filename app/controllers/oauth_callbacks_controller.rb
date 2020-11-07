# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
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
    if auth.info['email']
      @user = User.find_for_oauth(auth)

      if @user&.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
      else
        redirect_to root_path, alert: 'Something went wrong'
      end
    else
      session[:auth] = auth
      redirect_to email_confirmation_path
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
