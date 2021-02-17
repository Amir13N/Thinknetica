class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = user.questions.select { |question| question.created_at.today? }
    mail to: user.email, subject: 'Last day statistics'
  end
end
