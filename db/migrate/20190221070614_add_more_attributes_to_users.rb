class AddMoreAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :active, :boolean
    add_column :users, :country_code, :string, limit: 3
    add_column :users, :city, :string
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :phone, :string

  end
end
