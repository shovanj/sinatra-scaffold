Simple sinatra extension that can be used to create a quick admin interface to access table contents. Uses activerecord to fetch table info and data.

### Usage:

1. Require your AR model files in your app. eg:

```ruby
Dir["#{File.dirname(__FILE__)}/models/*.rb"].sort!.each {|f| require_relative f}
```

2. Register the extension in your sinatra app. Add will_paginate extension for pagination.

```ruby
register Sinatra::Scaffold
register WillPaginate::Sinatra
```

3. Set database connection inside the sinatra app.

```ruby
ActiveRecord::Base.
  establish_connection(
  :adapter  => "mysql2",
  :database => "scaffold_dev",
  :username => 'root',
  :password => '',
  :host => 'localhost'
  )
)
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
scaffold(:users) {|c| c.only([:first_name, :last_name])}
```


### Sample App:


```ruby
  require 'active_record'
  Dir["#{File.dirname(__FILE__)}/models/*.rb"].sort!.each {|f| require_relative f}

  ActiveRecord::Base.establish_connection(
    :adapter  => "mysql2",
    :database => "scaffold_dev",
    :username => 'root',
    :password => '',
    :host => 'localhost'
  )
                                                                                                                                            
                                                                                                                                        class ScaffoldApp < Sinatra::Base
                                                                                                                                          register Sinatra::Scaffold
    register WillPaginate::Sinatra
    
    ScaffoldApp.database_connection = ActiveRecord::Base.connection
    
    scaffold(:all) { |config|
      config.hide([:lock_version, :created_at, :bench_marked_at, :id])
    }
    
    scaffold(:users) {|c| c.only([:first_name, :last_name])}
 end
```
