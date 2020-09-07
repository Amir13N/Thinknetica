class UsersMailer < ApplicationMailer
  def confirm_email(email)
    mail to: 'heheheh@mail.ru', subject: 'Teschu'
  end
end