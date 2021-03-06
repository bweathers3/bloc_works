require_relative "../lib/bloc_works"

require 'test/unit'
require 'rack/test'

class BlocWorksTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application.new
  end

  def test_call
    get ""
    assert last_response.ok?
    assert_equal "Hello Blocheads!", last_response.body
  end

end
