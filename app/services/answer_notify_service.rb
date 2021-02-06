class AnswerNotifyService
  def notify(answer)
    answer.question.subscribers.find_each(batch_size: 500) do |user|
      AnswerNotifyMailer.answer_create(answer, user.email).deliver_later
    end
  end
end
