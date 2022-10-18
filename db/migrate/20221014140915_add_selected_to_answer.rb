class AddSelectedToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :selected, :boolean, null: false, default: false
  end
end
