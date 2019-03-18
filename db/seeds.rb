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