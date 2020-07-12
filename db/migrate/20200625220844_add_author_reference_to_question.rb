class AddAuthorReferenceToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :author, index: true
  end
end
