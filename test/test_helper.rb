require 'bundler/setup'
require 'active_record'
require 'test/unit'
require File.expand_path('../../lib/sinatrascaffold', __FILE__)
require 'rack/test'

ENV['RACK_ENV'] = 'test'

DB = ActiveRecord::Base.establish_connection(
                                             :adapter => "sqlite3",
                                             :dbfile  => ":memory:",
                                             :database => "sinatra-scaffold-test"
                                             )

ActiveRecord::Base.connection.drop_table :albums if ActiveRecord::Base.connection.table_exists?(:albums)
ActiveRecord::Base.connection.drop_table :tracks if ActiveRecord::Base.connection.table_exists?(:tracks)

ActiveRecord::Schema.define do
  
  unless ActiveRecord::Base.connection.table_exists? :albums
    create_table :albums do |table|
      table.column :title, :string
      table.column :performer, :string
    end
  end

  unless ActiveRecord::Base.connection.table_exists? :tracks
    create_table :tracks do |table|
      table.column :album_id, :integer
      table.column :track_number, :integer
      table.column :title, :string
    end
  end

end

class Album < ActiveRecord::Base
  attr_reader :title
end

class Track < ActiveRecord::Base
  
end

class App < Sinatra::Base
  register Sinatra::Scaffold
end
