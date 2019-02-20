class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name, null:false
      t.references :library, foreign_key: true
      t.string :isbn, null: false
      t.string :author, null: false, default: ''
      t.text :description
      t.string :cover_image
      t.integer :number_of_pages, null:false, default:0
      t.integer :format, null: false, default: 0
      t.string :publisher
      t.date :pub_date
      t.integer :language, null: false
      t.boolean :available

      t.timestamps
    end
    add_index :books, :name
    add_index :books, :isbn, unique: true
    add_index :books, :author
  end
end
