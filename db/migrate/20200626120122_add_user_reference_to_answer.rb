class AddUserReferenceToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user, index: true
  end
end
