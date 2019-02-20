class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :type, null: false, default: 0
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.references :loan, index: true
      t.datetime :date, null: false
      t.datetime :due_date
      t.boolean :returned, defaullt: false

      t.timestamps
    end
  end
end
