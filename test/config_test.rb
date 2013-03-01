require_relative 'test_helper'

class ErrorTest < Test::Unit::TestCase
  def test_for_database_connection
    App.database_connection = nil
    assert_raises(RuntimeError) do
      App.instance_eval { set_defaults }
    end
  end
end

class ConfigTest < Test::Unit::TestCase

  include Sinatra::Scaffold

  App.instance_eval do
    App.database_connection = ActiveRecord::Base.connection
  end

  def setup
    App.instance_eval { set_defaults }
    @config = Sinatra::Scaffold::Config.new([:albums], App)
  end

  def test_hide
    @config.hide :performer
    assert App.hidden_columns[:albums].include? :performer
  end

  def test_show
    @config.show :name, :id
    assert !(App.hidden_columns[:albums].include? :name)
  end

  def test_hidden_columns
    assert App.hidden_columns[:albums].empty?
  end

  def test_only
    @config.only :performer
    assert_equal App.hidden_columns[:albums], [:id, :title]
    assert_equal App.columns(:albums), [:performer]
  end

end
