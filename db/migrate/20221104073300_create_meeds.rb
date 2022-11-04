class CreateMeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :meeds do |t|
      t.string :name, null: false
      t.references :question, null: false, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
