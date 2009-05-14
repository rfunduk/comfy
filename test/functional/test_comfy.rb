require 'test/test_helper'

class TestComfy < Test::Unit::TestCase
  include Comfy

  def setup
    Database.reset!( 'comfytest-realworld' )
  end

  def test_1
    # do a lot of nothing
  end

  def test_2
  end

end
