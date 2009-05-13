module Comfy
  class IntegrationTests
    def self.reset
      Database.destroy!( 'comfytest-realworld' )
      @db = Database.new( 'comfytest-realworld' )
    end

    def self.test1
      self.reset
      # do a lot of nothing
    end
  
    def self.test2
    end

  end
end
