module Comfy
  class Database
    include Comfy

    attr_reader :uri

    def initialize( name )
      @name = name
      @uri = Database.uri( name )
      begin
        Database.find( name ).ensure( :has => 'db_name' )
      rescue ResponseSanityFail
        Database.create( name ).ensure( :has => 'ok' )
      end
    end

    # *** INSTANCE METHODS ***

    def info
      get( '' ).to_doc
    end
    
    def all
      get( '_all_docs', { :include_docs => true } ).to_doc.rows.collect do |row|
        Document.new( self, row['doc'] )
      end
    end

    def get( uri, params={} )
      uri += '?' + params.collect { |p| p.join( '=' ) }.join( '&' ) \
        unless params.empty?
      Response.new( RCW.get( @uri + '/' + uri ), self )
    end

    # *** CLASS METHODS ***

    def self.destroy!( uri )
      Response.new( RCW.delete( Database.uri( uri ) ), self ) rescue nil
    end

    protected

    def self.find( db )
      Response.new( RCW.get( Database.uri( db ) ), self )
    end

    def self.create( db )
      Response.new( RCW.put( Database.uri( db ) ), self )
    end

    def self.uri( uri )
      uri !~ %r{^http://} ? "http://localhost:5984/#{uri}" : uri
    end

  end
end
