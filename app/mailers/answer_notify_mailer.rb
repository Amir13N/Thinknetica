class AnswerNotifyMailer < ApplicationMailer
  def answer_create(answer)
    @question_title = answer.question.title
    @answer_user_email = answer.user.email
    mail to: answer.question.user.email, subject: 'Answer creation'
  end
end
