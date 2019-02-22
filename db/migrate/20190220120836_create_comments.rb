class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.text :content, null:false, default: ''

      t.timestamps
    end
  end
end
