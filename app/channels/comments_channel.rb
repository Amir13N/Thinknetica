# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "#{data['commentable_name']}/#{data['commentable_id']}/comments"
  end
end
