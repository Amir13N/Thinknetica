# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from 'answers'
  end
end
