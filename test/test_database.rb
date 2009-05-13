require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../lib/' )
require 'comfy'

class TestDatabase < Test::Unit::TestCase
  include Comfy

  def setup
    Database.destroy!( 'idontexist' )
    Database.destroy!( 'comfytest-unit' )
    @db = Database.new( 'comfytest-unit' )
  end

  def test_no_such_db
    Database.new( 'idontexist' )
  end

  def test_db_info
    assert_nothing_raised do
      info = @db.info
      doc_count = info.doc_count
      disk_size = info.disk_size
    end
  end
  
  def test_all_docs
    assert_equal 0, @db.all.length
  end

end
