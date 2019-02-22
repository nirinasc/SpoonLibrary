class RenameTypeToLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :logs, :type, :classification 
  end
end
