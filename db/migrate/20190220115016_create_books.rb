class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name, null:false
      t.references :library, foreign_key: true
      t.string :isbn, null:false
      t.text :description
      t.string :cover_image
      t.integer :number_of_pages, null:false, default:0
      t.integer :format
      t.string :publisher
      t.date :pub_date
      t.integer :language
      t.boolean :available

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
