class AddAuthorReferenceToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :author, foreign_key: true
  end
end
