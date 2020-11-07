class UsersController < ApplicationController
  def email_confirmation
    @user = User.new
    @auth = session[:auth]
  end

  def confirm_email
    @user = User.find_for_oauth(@auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def send_email_confirmation_message
    UsersMailer.confirm_email(email_param).deliver
  end

  private

  def email_param
    params.require(:user).permit(:email)[:email]
  end
end