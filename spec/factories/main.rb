FactoryBot.define do
    factory :book do 
        name { Faker::Book.title }
        publisher { Faker::Book.publisher }
    end
end