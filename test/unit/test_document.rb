require 'test/test_helper'

class TestDocument < Test::Unit::TestCase
  include Comfy

  def setup
    Database.reset!( 'comfytest' )
    @fake_doc = { :a => 1, :b => 2, :c => 3 }
  end

  def test_reading_properties
    assert_equal 0, Comfy::Config.db.info.doc_count
  end

  def test_writing_properties
    info = Comfy::Config.db.info
    assert_equal 0, info.doc_count
    info.doc_count = 1
    assert_equal 1, info.doc_count
  end

  def test_to_json
    # given a json document, Document#to_json should yield the input again
    assert_equal JSON.parse( @fake_doc.to_json ),
                 JSON.parse( Document.new( @fake_doc ).to_json )
  end

  def test_doc_create
    Document.new( @fake_doc ).save
    assert_equal 1, Comfy::Config.db.all.length
    assert_equal 1, Comfy::Config.db.info.doc_count
  end

  def test_doc_update
    doc = Document.new( @fake_doc )
    assert !doc._id
    doc.save
    assert doc._id
    rev = doc._rev
    
    doc.a = 5
    doc.b += 1
    doc.save
    
    assert_equal 5, doc.a
    assert_not_equal doc.b, @fake_doc[:b]
    
    raw_doc = Document.get( doc._id )
    assert_equal doc, raw_doc
    assert_not_equal rev, raw_doc._rev 
  end

  def test_doc_get
    doc = Document.new( @fake_doc )
    doc.save
    retrieved_doc = Document.get( doc._id )
    
    assert_equal retrieved_doc._id, doc._id
    assert Comfy::Config.db.all.include?( retrieved_doc )
    assert_equal 1, Comfy::Config.db.all.length
    assert_equal 1, Comfy::Config.db.info.doc_count
  end

  def test_doc_delete
    doc = Document.new( @fake_doc )
    doc.save
    
    assert_equal 1, Comfy::Config.db.info.doc_count
    assert doc.delete.is_a?( Response )
    assert_equal 0, Comfy::Config.db.info.doc_count
  end

  def test_doc_add_field
    doc = Document.new( @fake_doc )
    doc.add_field 'omg', 1
    assert_equal 1, doc.omg
  end

  def test_doc_update_field
    doc = Document.new( @fake_doc )
    doc.update_field 'omg', 1
    assert_equal 1, doc.omg
  end

  def test_doc_remove_field
    doc = Document.new( @fake_doc )
    doc.add_field 'omg', 1
    assert_equal 1, doc.omg
    
    doc.remove_field 'omg'
    assert_nil doc.omg
  end

end
