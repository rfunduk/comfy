require 'test/test_helper'

class TestDatabase < Test::Unit::TestCase
  include Comfy

  def setup
    Database.destroy!( 'idontexist' )
    Database.reset!( 'comfytest' )
  end

  def test_no_such_db
    Database.new( 'idontexist' )
  end

  def test_db_info
    assert_nothing_raised do
      info = Comfy::Config.db.info
      doc_count = info.doc_count
      disk_size = info.disk_size
    end
  end
  
  def test_all_docs
    assert_equal 0, Comfy::Config.db.all.length
  end

end
