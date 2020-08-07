# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "#{data['question_id']}/comments"
  end
end
