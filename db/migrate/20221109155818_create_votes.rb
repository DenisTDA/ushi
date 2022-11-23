class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :voter, null: false, foreign_key: { to_table: :users }
      t.references :voteable, polymorphic: true, null: false
      t.boolean :useful, null: false

      t.timestamps
    end
  end
end
