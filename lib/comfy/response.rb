module Comfy

  class Response
    include Comfy

    def initialize( result, db=COMFY_DB )
      @db = db
      @result = {}
      JSON.parse( result ).entries.each do |key, value|
        case key.is_a?( String )
        when true then key = '_' + key if Object.respond_to? key
        end
        @result[key] = value
      end
      @result
    end
    
    def method_missing( method, *args, &block )
      method = method.to_s
      if method =~ /=$/
        method.sub!(/=$/, '')
        @result[method] = *args if @result.has_key?( method )
      else
        @result[method] if @result.has_key?( method )
      end
    end

    def ensure( *args )
      args.first.entries.each do |key, value|
        case key
        when :has
          raise Comfy::ResponseSanityFail,
                "Expected key: #{value} in: #{@result.inspect}" \
            unless @result.has_key?( value.to_s )
        when :lacks
          raise Comfy::ResponseSanityFail,
                "Unexpected key: #{value} in #{@result.inspect}" \
            if @result.has_key?( value.to_s )
        end
      end
    end

    def to_doc
      Document.new( @result )
    end

  end

end
