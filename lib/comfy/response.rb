module Comfy

  class Response

    def initialize( result )
      @result = JSON.parse( result )
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
