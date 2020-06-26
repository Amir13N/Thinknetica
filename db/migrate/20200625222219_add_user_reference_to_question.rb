class AddUserReferenceToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, index: true
  end
end
