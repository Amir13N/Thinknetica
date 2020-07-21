# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.boolean :positive
      t.references :user
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
