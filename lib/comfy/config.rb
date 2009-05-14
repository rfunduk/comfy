module Comfy
  class Config
    DEFAULT_URI = 'comfy'

    def self.set_database( uri )
      @@db = Database.new( uri )
    end

    def self.db
      @@db ||= Database.new( uri )
    end
  end
end
