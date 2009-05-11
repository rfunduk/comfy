module Comfy

  class Document
    def initialize( hash={} )
      @__hash = hash
    end

    def method_missing( method, *args, &block )
      if method =~ /=$/
        method.sub!(/=$/, '')
        @@_hash[method] = *args
      else
        @__hash[method] if @__hash.has_key?( method )
      end
    end

    def to_json
      @__hash.to_json
    end
  end

end
