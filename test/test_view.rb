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
    @fake_view = { :map => "function( doc ) { emit( doc._id, null ); }" }
  end

  def test_view_create
    design_doc = View.create( @db, 'something/all', @fake_view )
    assert_equal @fake_view[:map], design_doc.views['all']['map']
  end

  def test_view_update
    design_doc = View.create( @db, 'something/all', @fake_view )

    new_map = "function( doc ) { emit( null, doc._id ); }"
    design_doc.views['all']['map'] = new_map
    design_doc.save
    assert_equal new_map, design_doc.views['all']['map']

    raw_doc = @db.get( '_design/something' )
    assert_equal new_map, raw_doc.views['all']['map']
  end

  def test_map_view_run_with_include_docs
    View.create( @db, 'something/all', @fake_view )
    results = View.run( @db, 'something/all', { :include_docs => true } )
    assert_equal 0, results.total_rows

    # create a doc which will be returned
    doc = Document.new( @db, { :time_for => 'some thrilling heroics' } )
    doc.save

    results = View.run( @db, 'something/all', { :include_docs => true } )
    assert_equal 1, results.total_rows
    assert_equal doc, results.rows.first
  end

  def test_map_view_run
    View.create( @db, 'something/all', @fake_view )
    results = View.run( @db, 'something/all', { :include_docs => true } )
    assert_equal 0, results.total_rows

    # create a doc which will be returned
    doc = Document.new( @db, { :time_for => 'some thrilling heroics' } )
    doc.save

    results = View.run( @db, 'something/all' )
    assert_equal 1, results.total_rows
    assert_equal doc._id, results.rows.first._id
  end

  def test_reduce_view_run
    # make a couple docs to reduce
    docs = [
      { :letter => 'Ehh' },
      { :letter => 'Bee' },
      { :letter => 'See' },
      { :letter => 'Bee' },
      { :letter => 'Ehh' }
    ]
    total = 0
    docs.map do |doc|
      total += 1
      Document.new( @db, doc ).save
    end

    assert_equal docs.length, @db.info.doc_count

    # now create the view
    view = { :map => "function( doc ) { emit( doc.letter, 1 ); }",
             :reduce => "function( keys, values ) { return sum( values ); }" }
    View.create( @db, 'something/total', view )

    # run it
    results = View.run( @db, 'something/total', { :reduce => true } )
    assert_equal total, results.rows.first.value
  end

  def test_group_view_run
    # make a couple docs to group
    docs = [
      { :letter => 'Ehh', :count => 4 },
      { :letter => 'Bee', :count => 1 },
      { :letter => 'See', :count => 2 },
      { :letter => 'Bee', :count => 2 },
      { :letter => 'Ehh', :count => 1 }
    ]
    totals = {}
    docs.map do |doc|
      totals[doc[:letter]] ||= 0
      totals[doc[:letter]] += doc[:count]
      Document.new( @db, doc ).save
    end

    assert_equal docs.length, @db.info.doc_count

    # create the view
    view = { :map => "function( doc ) { emit( doc.letter, doc.count ); }",
             :reduce => "function( keys, values ) { return sum( values ); }" }
    View.create( @db, 'something/grouped', view )

    # run it
    results = View.run( @db, 'something/grouped', { :group => true } )
    results.rows.each do |doc|
      assert_equal totals[doc.key], doc.value
    end
  end
end
