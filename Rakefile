require 'rubygems'
require 'redgreen'
require 'test/unit/ui/console/testrunner'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/lib/' )
require 'comfy'
require 'test/integration'
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

  # integration tests
  1.upto( 10 ) do |i|
    break unless IntegrationTests.respond_to?( :"test_#{i}" )
    puts "-- Integration Test #{i} --"
    IntegrationTests.send( :"test_#{i}" )
  end
end
