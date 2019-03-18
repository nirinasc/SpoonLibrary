# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# create admin user
if User.count < 1
    User.create!([
        email: 'admin@spoonlibrary.com',
        username: 'spoonlibrarian',
        password: 'spoonL123',
        firstname: 'John',
        lastname: 'Doe',
        role: 1,
        active: true
    ])
end

# seed Libraries
if Library.count < 1
  # create 1 Library in  Mauritius
  Library.create(name: 'Mauritius Library', country_code: 'MU', city: 'Rose Hill', address: 'Ebene Junction', phone: 	+33545451151)

  # create another Library in  Madagascar
  Library.create(name: 'Madagascar Library', country_code: 'MG', city: 'Antananarivo', address: '41141')
end

# seed Categories
if Category.count < 1
  30.times do
    FactoryBot.create(:category)
  end
end

# seed Books
if Book.count < 1
  100.times do |index|
    FactoryBot.create(:book, library: (index % 2).zero? ? Library.first : Library.last, categories: Category.first(5))
  end
end
