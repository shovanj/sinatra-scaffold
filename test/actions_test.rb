require_relative 'test_helper'

App.instance_eval do

  register WillPaginate::Sinatra

  set :method_override, true

  App.database_connection = ActiveRecord::Base.connection
  scaffold :all do |config|
    config.hide :id
  end
  
end

class ActionsTest < Test::Unit::TestCase

  include Rack::Test::Methods
  
  def app
    App
  end

  # test get actions

  # test delete actions
  def test_delete_action_200_status
    album = Album.create(:title => "10,000 days", :performer => "Tool")
    current_session.header 'X-Requested-With', 'XMLHttpRequest'
    delete "/albums/#{album.id}"
    assert_equal last_response.status, 200, "Expected 200 status when delete succeeds"
  end
  
  def test_delete_action_403_status
    delete '/albums/1'
    assert_equal last_response.status, 403, "Expected 403 status for non ajax request"
  end

  def test_delete_action_404_status
    current_session.header 'X-Requested-With', 'XMLHttpRequest'
    delete '/albums/1'
    assert_equal last_response.status, 404, "Expected 404 status if delete fails"
  end

end
