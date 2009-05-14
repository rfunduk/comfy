require 'test/test_helper'

class TestResponse < Test::Unit::TestCase
  include Comfy

  def setup
    @doc = { :ok => true, :weak => 'sauce', :answer => 42 }
    @response = Response.new( @doc.to_json )
  end

  def test_has
    assert_nothing_raised do
      @response.ensure( :has => 'ok' )
    end

    assert_raises Comfy::ResponseSanityFail do
      @response.ensure( :has => 'style' )
    end
  end

  def test_lacks
    assert_nothing_raised do
      @response.ensure( :lacks => 'style' )
    end

    assert_raises Comfy::ResponseSanityFail do
      @response.ensure( :lacks => 'ok' )
    end
  end

  def test_to_doc
    @doc.entries.each do |key, value|
      assert_equal value, @response.send( key )
    end
  end

  def test_name_mangling
    @doc['id'] = 'laksjdf'
    @doc['to_s'] = 'not_a_function'

    @response = Response.new( @doc.to_json )

    assert_equal @doc['id'], @response._id
    assert_equal @doc['to_s'], @response._to_s
    assert_not_equal @doc['to_s'], @response.to_s
  end
end
