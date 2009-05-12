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
    design_doc = View.create( @db, 'something', 'all', @fake_view )
    assert_equal @fake_view[:map], design_doc.views['all']['map']
  end

  def test_view_update
    design_doc = View.create( @db, 'something', 'all', @fake_view )

    new_map = "function( doc ) { emit( null, doc._id ); }"
    design_doc.views['all']['map'] = new_map
    design_doc.save
    assert_equal new_map, design_doc.views['all']['map']

    raw_doc = @db.get( '_design/something' )
    assert_equal new_map, raw_doc.views['all']['map']
  end

  def test_view_run
    View.create( @db, 'something', 'all', @fake_view )
    results = View.run( @db, 'something', 'all', { :include_docs => true } )
    assert_equal 0, results.total_rows

    # create a doc which will be returned
    doc = Document.new( @db, { :time_for => 'some thrilling heroics' } )
    doc.save

    results = View.run( @db, 'something', 'all', { :include_docs => true } )
    assert_equal 1, results.total_rows

    assert_equal doc, results.rows.first
  end
end
