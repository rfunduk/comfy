require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../lib/' )
require 'comfy'

class TestDocument < Test::Unit::TestCase

  def setup
    @db = Comfy::Database.new( 'comfytest' )
  end

  def test_reading_properties
    assert_equal 0, @db.info.doc_count
  end

  def test_writing_properties
    info = @db.info
    assert_equal 0, info.doc_count
    info.doc_count = 1
    assert_equal 1, info.doc_count
  end

  def test_to_json
    # given a json document, Document#to_json should yield the input again
    doc = { :a => 1, :b => 2, :c => 3 }.to_json
    assert_equal JSON.parse( doc ),
                 JSON.parse( Comfy::Document.new( doc ).to_json )
  end

end
