require 'rubygems'
require 'redgreen'
require 'test/unit/ui/console/testrunner'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/lib/' )
require 'comfy'
include Comfy

TESTS = [ 
  [ 'unit', [ Database, Document, View, Response ] ],
  [ 'functional', [ Comfy ] ]
]

task :default do
  TESTS.entries.each do |type, classes|
    classes.each do |klass|
      puts "Testing - #{klass}..."
      base_klass = klass.name.split( '::' ).last
      require "test/#{type.to_s}/test_#{base_klass.downcase}.rb"
      Test::Unit::UI::Console::TestRunner.run(
        Kernel.const_get( 'Test' + base_klass )
      )
    end
  end
end
