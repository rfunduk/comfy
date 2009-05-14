require 'test/test_helper'

class TestDatabase < Test::Unit::TestCase
  include Comfy

  def setup
    Database.destroy!( 'idontexist' )
    Database.reset!( 'comfytest-unit' )
  end

  def test_no_such_db
    Database.new( 'idontexist' )
  end

  def test_db_info
    assert_nothing_raised do
      info = COMFY_DB.info
      doc_count = info.doc_count
      disk_size = info.disk_size
    end
  end
  
  def test_all_docs
    assert_equal 0, COMFY_DB.all.length
  end

end
