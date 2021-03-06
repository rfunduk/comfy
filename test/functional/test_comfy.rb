require 'test/test_helper'

class TestComfy < Test::Unit::TestCase
  include Comfy

  def setup
    Database.reset!( 'comfytest' )
  end

  def test_1
    # make sure we start with an empty db
    assert_equal 0, Comfy::Config.db.all.size
    
    # ask for it's URI
    assert_match /comfytest$/, Comfy::Config.db.uri
    
    # create a document
    doc = Document.new( { :a => 1, :b => 2, :c => 3 } )
    doc.save
    
    # make sure it has an id and a rev
    assert_not_nil doc._id
    assert_not_nil doc._rev
    
    # should be 1 doc in the db now
    assert_equal 1, Comfy::Config.db.all.size
    
    # make 5 docs
    docs = (1..5).collect { |i| Document.new( { :value => i } ) }
    assert_equal 5, docs.size
    
    # bulk save them
    saved_docs = Document.bulk_save docs
    
    # and now there should be six
    assert_equal 6, Comfy::Config.db.all.size
    
    # make sure that each doc we got back, upon pulling it
    # out of the database again, matches with the values in
    # the return of bulk_save
    saved_docs.each do |doc|
      # get the doc again
      fresh = Document.get( doc._id )
      # make sure it's the same
      assert_equal doc.value, fresh.value
    end

    # now do a bulk_get and make sure all the docs are correct
    all_docs = Document.bulk_get saved_docs.collect { |doc| doc._id }
    all_docs.zip( saved_docs ).each do |fresh, original|
      assert_equal original, fresh
    end
  end

end
