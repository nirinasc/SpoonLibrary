# README

## Installation

To run this application, please follow theses steps:

clone the repos
```shell
git clone https://github.com/nirinasc/SpoonLibrary.git spoonlibrary
```

Go to the project directory root
```shell
cd spoonlibrary
```

Install gems dependency
```shell
bundle install
```

Configure your database as follows:

1. Go to your config folder
```shell
cd config
```
2. copy the file database.yml.example and rename it to database.yml

Run Migrations and seeds files
```shell
rails db:migrate
rails db:seed
```

To run the application:
```shell
rails s
```

## Tests

To run spec tests, type the followed command
```shell
bundle exec rspec
```

The api docs are located in http://localhost:3000/docs/swagger_docs/v1
To generate them, tape the command bellow
```shell
bundle exec rake swagger
```
