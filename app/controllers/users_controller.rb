class UsersController < ApplicationController
  def email_confirmation
    @user = User.new
  end

  def confirm_email
  end

  def send_email_confirmation_message
    UsersMailer.confirm_email(email_params)
  end

  private

  def email_params
    
  end
end