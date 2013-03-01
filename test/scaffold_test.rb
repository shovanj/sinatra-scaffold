require_relative 'test_helper'

App.instance_eval do
  App.database_connection = ActiveRecord::Base.connection
  scaffold :all do |config|
    config.hide :id
  end
  scaffold :albums do |config|
    config.hide :performer
    config.search :title
  end
  scaffold :tracks do |config|
    config.search :title
  end
end

class ScaffoldTest < Test::Unit::TestCase

  def app
    App
  end

  def test_hide_using_scaffold
    assert app.hidden_columns[:albums].include? :performer
    assert app.hidden_columns[:tracks].include?(:id), "Hidden columns for orders should not have price."
  end

  def test_search_using_scaffold
    assert app.searchable_columns[:albums].include? :title
    assert app.searchable_columns[:tracks].include? :title
    assert !(app.searchable_columns[:albums].include?(:price)), "Searchable columns should not have price."
  end

end


class AppTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def app
    App
  end

end
