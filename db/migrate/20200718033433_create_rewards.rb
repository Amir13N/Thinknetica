# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.string :picture
      t.references :question
      t.references :user

      t.timestamps
    end
  end
end
