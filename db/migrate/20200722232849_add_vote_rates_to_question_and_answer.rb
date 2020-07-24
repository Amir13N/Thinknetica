# frozen_string_literal: true

class AddVoteRatesToQuestionAndAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :vote_rates, :text, array: true, default: []
    add_column :answers, :vote_rates, :text, array: true, default: []
  end
end
