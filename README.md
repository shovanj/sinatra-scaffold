Simple sinatra extension that can be used to display records. Uses sequel gem to fetch table info and data.

### Usage:

1 Register the extension in your sinatra app.

```ruby
register Sinatra::Scaffold
```

2 Set database connection inside the app.

```ruby
set_database Sequel.mysql2(:user => 'root', :host => 'localhost', :database => 'db_name',:password=>'')
```

3 Specify tables and respective columns that you want to display.

```ruby
# following will generate /users url that will display the records in a table.
# to use search functionality simply add columns that you want to be searchable.
scaffold :users do |config|
  config.hide :password_digest, :security_answer
  config.search :name, :email, :login
end

# following will only display colums that are specified
scaffold :items do |config|
  config.only :name, :email
end
```

### Sample App:


```ruby
# connect to an in-memory database
DB = Sequel.sqlite

# create an items table
DB.create_table :items do
  primary_key :id
  String :name
  Float :price
end

# create a dataset from the items table
items = DB[:items]

# populate the table
items.insert(:name => 'abc', :price => rand * 100)
items.insert(:name => 'def', :price => rand * 100)
items.insert(:name => 'ghi', :price => rand * 100)

class AdminApp < Sinatra::Base

  register Sinatra::Scaffold

  set_database DB

  scaffold(:all) { |config| config.hide(:id) }
  scaffold :items do |config|
    config.search :name
    config.only :id, :name
  end
end
```
