class RealWorld
  def self.reset
    Database.destroy!( 'rwt' )
    @db = Database.new( 'rwt' )
  end

  def self.real_world_1
    self.reset
    # do a lot of nothing
  end

  def self.real_world_2
    self.reset
    # wow this is a really worthwhile test
  end
end
