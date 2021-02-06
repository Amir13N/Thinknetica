class CreateQuestionsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :questions_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
