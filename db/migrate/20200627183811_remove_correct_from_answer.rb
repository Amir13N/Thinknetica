# frozen_string_literal: true

class RemoveCorrectFromAnswer < ActiveRecord::Migration[6.0]
  def change
    remove_column :answers, :correct
  end
end
