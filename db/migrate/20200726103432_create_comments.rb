# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user
      t.references :commentable, polymorphic: true

      t.timestamps
    end
  end
end
