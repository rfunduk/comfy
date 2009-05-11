require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../lib/' )
require 'comfy'

class TestDocument < Test::Unit::TestCase
  include Comfy

  def setup
    Database.destroy!( 'comfytest' )
    @db = Database.new( 'comfytest' )
    @fake_doc = { :a => 1, :b => 2, :c => 3 }
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
    assert_equal JSON.parse( @fake_doc.to_json ),
                 JSON.parse( Document.new( @db, @fake_doc ).to_json )
  end
  
  def test_doc_create
    Document.new( @db, @fake_doc ).save
    assert_equal 1, @db.all.length
    assert_equal 1, @db.info.doc_count
  end
  
  def test_doc_get
    doc = Document.new( @db, @fake_doc )
    doc.save
    retrieved_doc = @db.get( doc._id ).to_doc
    
    assert_equal retrieved_doc._id, doc._id
    assert @db.all.include?( retrieved_doc )
    assert_equal 1, @db.all.length
    assert_equal 1, @db.info.doc_count
  end

end
