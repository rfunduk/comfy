module Comfy

  class Document
    include Comfy
    
    attr_reader :db
    
    def initialize( db, hash={} )
      hash = JSON.parse( hash ) if hash.is_a? String
      @__hash = hash
      @db = db
    end
    
    def method_missing( method, *args, &block )
      method = method.to_s
      if method =~ /=$/
        method.sub!(/=$/, '')
        @__hash[method] = *args
      else
        @__hash[method] if @__hash.has_key?( method )
      end
    end

    def to_json
      @__hash.to_json
    end
    
    def ==( other )
      return false unless @db == other.db
      @__hash.entries.each do |key, value|
        return false unless other.send( key ) == value
      end
      return true
    end
    
    def save
      raise Comfy::UnsaveableDocumentException if @db.nil?
      
      if @__hash.has_key?( '_id' )
        result = RCW.put( "#{@db.uri}/#{@__hash['_id']}", @__hash.to_json,
                          :content_type => 'application/json' )
      else
        result = RCW.post( @db.uri, @__hash.to_json,
                           :content_type => 'application/json' )
      end
      
      response = Response.new( result )
      @__hash['_id'] = response._id
      return response
    end
    
  end

end
