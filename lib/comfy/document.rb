module Comfy

  class Document
    def initialize( hash={} )
      hash = JSON.parse( hash ) if hash.is_a? String
      @__hash = hash
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
  end

end
