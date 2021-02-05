class AnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotifyMailer.answer_create(answer).deliver_later
  end
end
