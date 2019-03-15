class AddStatusToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :status, :integer, default: 0
    add_index :books, :status
  end
end
