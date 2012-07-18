require_relative 'test_helper'

TABLES = [:items]

class ErrorTest < Test::Unit::TestCase
  def test_for_database_connection
    App.database = nil
    assert_raises(RuntimeError) do
      App.instance_eval { set_defaults }
    end
  end
end

class ConfigTest < Test::Unit::TestCase

  include Sinatra::Scaffold

  App.instance_eval do
    set_database DB
  end

  def app
    App
  end

  def setup
    # app.set_defaults
    app.instance_eval { set_defaults }
    @config = Config.new(TABLES, app)
  end

  def test_hide
    @config.hide :price
    assert app.hidden_columns[:items].include? :price
  end

  def test_show
    @config.show :name, :id
    assert !(app.hidden_columns[:items].include? :name)
  end

  def test_hidden_columns
    assert app.hidden_columns[:items].empty?
  end

end
