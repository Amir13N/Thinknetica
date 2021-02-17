class AnswerNotifyService
  def notify(answer)
    answer.question.subscribers do |user|
      AnswerNotifyMailer.answer_create(answer, user.email).deliver_later
    end
  end
end
