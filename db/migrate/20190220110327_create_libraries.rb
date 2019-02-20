class CreateLibraries < ActiveRecord::Migration[5.2]
  def change
    create_table :libraries do |t|
      t.string :name, null: false, default: ''
      t.string :country_code, limit:3, null:false
      t.string :city
      t.string :address
      t.string :zip_code
      t.string :phone

      t.timestamps
    end
  end
end
