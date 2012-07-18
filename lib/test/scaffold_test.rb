require_relative 'test_helper'

App.instance_eval do
  set_database DB
  scaffold :all do |config|
    config.hide :id
  end
  scaffold :items do |config|
    config.hide :price
    config.search :manufacturer
  end
  scaffold :orders do |config|
    config.search :order_date
  end
end

class ScaffoldTest < Test::Unit::TestCase

  def app
    App
  end

  def test_hide_using_scaffold
    assert app.hidden_columns[:items].include? :price
    assert app.hidden_columns[:orders].include?(:id), "Hidden columns for orders should not have price."
  end

  def test_search_using_scaffold
    assert app.searchable_columns[:items].include? :manufacturer
    assert app.searchable_columns[:orders].include? :order_date
    assert !(app.searchable_columns[:items].include?(:price)), "Searchable columns should not have price."
  end

end


class AppTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def app
    App
  end

  def test_it_says_hello_world
    get '/items'
    assert last_response.ok?
    assert last_response.body.include?('Items')
  end

  def test_search_form
    get '/items'
    assert last_response.body.include?("<div id=\"search")
    assert last_response.body.include?(%(<input class="input" id="q" name="q[manufacturer]" type="text" value="">)), "Text field missing in the search form."
  end

end
