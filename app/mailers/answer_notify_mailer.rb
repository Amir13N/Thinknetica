class AnswerNotifyMailer < ApplicationMailer
  def answer_create(answer, user_email)
    @question_title = answer.question.title
    @answered_user_email = answer.user.email
    mail to: user_email, subject: 'Answer creation'
  end
end
