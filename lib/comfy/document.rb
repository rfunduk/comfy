module Comfy

  class Document
    include Comfy
    
    attr_reader :db
    
    def initialize( db, hash={} )
      hash = JSON.parse( hash ) if hash.is_a? String
      @__hash = {}
      hash.entries.each do |key, value|
        key = key.to_s if key.is_a? Symbol
        key = '_' + key if Object.respond_to? key
        @__hash[key] = value
      end
      @db = db
    end
    
    def method_missing( method, *args, &block )
      method = method.to_s
      if method =~ /=$/
        method.sub!(/=$/, '')
        @__hash[method] = *args if has?( method )
      else
        @__hash[method] if has?( method )
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
      
      if has?( '_id' )
        rev = "?rev=#{_rev}" if has?( '_rev' )
        result = RCW.put( "#{@db.uri}/#{_id}#{rev if rev}", @__hash.to_json,
                          :content_type => 'application/json' )
      else
        result = RCW.post( @db.uri, @__hash.to_json,
                           :content_type => 'application/json' )
      end
      
      response = Response.new( result )
      @__hash['_id'] = response._id
      @__hash['_rev'] = response.rev
      return response
    end

    def delete
      raise Comfy::UnsaveableDocumentException if @db.nil?

      begin
        result = RCW.delete( "#{@db.uri}/#{_id}?rev=#{_rev}" )
      rescue
        return false
      end

      return Response.new( result )
    end

    protected

    def has?( key )
      key = key.to_s if key.is_a? Symbol
      return @__hash.has_key?( key )
    end
    
  end

end
