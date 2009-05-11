require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../lib/' )
require 'comfy'

class TestDatabase < Test::Unit::TestCase

  def setup
    Comfy::Database.destroy!( 'idontexist' )
    @db = Comfy::Database.new( 'comfytest' )
  end

  def test_no_such_db
    Comfy::Database.new( 'idontexist' )
  end

  def test_db_info
    assert_nothing_raised do
      info = @db.info
      doc_count = info.doc_count
      disk_size = info.disk_size
    end
  end

end
