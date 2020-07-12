class AddAuthorForeignKeyToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :questions, :authors
  end
end
