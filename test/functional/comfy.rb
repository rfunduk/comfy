require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../../lib/' )
require 'comfy'

class ComfyTest < Test::Unit::TestCase
  include Comfy

  def setup
    Database.destroy!( 'comfytest-realworld' )
    @db = Database.new( 'comfytest-realworld' )
  end

  def test_1
    # do a lot of nothing
  end

  def test_2
  end

end
