# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "#{data['question_id']}/answers"
  end
end
