FactoryBot.define do

    factory :user do 
        role { Faker::Number.between(0, 1) }
        email { Faker::Internet.email }
        username { 'user' + Faker::Number.between(0,100).to_s }
        password { Faker::Internet.password }
        firstname { Faker::Name.first_name }
        lastname { Faker::Name.last_name }
        active { false }
        country_code { Faker::Address.country_code }
        city { Faker::Address.city }
        address { Faker::Address.street_address }
        zip_code { Faker::Address.zip_code }
        phone { Faker::PhoneNumber.phone_number }
    end

    factory :library do
       name { Faker::Company.name }
       country_code { Faker::Address.country_code }
       city { Faker::Address.city }
       address { Faker::Address.street_address }
       zip_code { Faker::Address.zip_code }
       phone { Faker::PhoneNumber.phone_number }
    end

    factory :category do 
        name { Faker::Book.genre }
        description { Faker::Books::Lovecraft.sentence }
    end

    factory :book do 
        name { Faker::Book.title }
        isbn { Faker::Code.isbn }
        description { Faker::Books::Lovecraft.sentence }
        number_of_pages { Faker::Number.number(3) }
        format { 0 }
        publisher { Faker::Book.publisher }
        pub_date { Faker::Date.backward(600) }
        language { Faker::Number.between(0, 1) }
        available { Faker::Boolean.boolean }
    end

    factory :comment do
        content { Faker::Lorem.paragraph(2) }
    end


    factory :book_loan, class: 'Log' do 
        classification { 0 }
        date { Date.today }
        due_date { 21.days.from_now }
        returned { false }
    end

    factory :book_return, class: 'Log' do 
        classification { 1 }
        date { Faker::Date.between(3.days.from_now, 21.days.from_now ) }
        returned { false }
    end

end