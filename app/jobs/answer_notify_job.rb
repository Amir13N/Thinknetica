class AnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotifyService.new.notify(answer)
  end
end
