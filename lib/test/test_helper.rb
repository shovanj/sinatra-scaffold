require 'bundler/setup'
require 'test/unit'
require '../sinatrascaffold'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

DB = Sequel.sqlite

# create an items table
DB.create_table :items do
  primary_key :id
  String :name
  String :manufacture
  Float :price
end

# create an items table
DB.create_table :orders do
  primary_key :id
  String :name
  Float :amount
  Int :quantity
  Date :order_date
end


class App < Sinatra::Base
  register Sinatra::Scaffold
end
