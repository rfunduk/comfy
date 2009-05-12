require 'rubygems'
require 'redgreen'
require 'test/unit/ui/console/testrunner'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/lib/' )
require 'comfy'
require 'test/real_world'
include Comfy

def test( klass )
  klass = klass.name.split( '::' ).last
  require "test/test_#{klass.downcase}.rb"
  Test::Unit::UI::Console::TestRunner.run(
    Kernel.const_get( 'Test' + klass )
  )
end

task :default do
  # unit tests
  [Database, Document, View, Response].each do |klass|
    puts "Testing - #{klass}..."
    test klass
  end

  # 'real world' tests
  1.upto( 10 ) do |i|
    break unless RealWorld.respond_to?( :"real_world_#{i}" )
    puts "-- RealWorld Test #{i} --"
    RealWorld.send( :"real_world_#{i}" )
  end
end
