require_relative 'test_helper'

class FirstTest < Minitest::Test
  def test_we_have_the_version
    assert_equal Guessr::VERSION, '0.0.1'
  end
end
