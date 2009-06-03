require 'rubygems'
require 'redgreen'
require 'test/unit/ui/console/testrunner'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/lib/' )
require 'comfy'
include Comfy

TESTS = { 
  :unit  => [ Database, Document, View, Response ],
  :functional => [ Comfy ]
}

def test( klass, test_type )
  puts "Testing - #{klass}..."
  base_klass = klass.name.split( '::' ).last
  require "test/#{test_type}/test_#{base_klass.downcase}.rb"
  Test::Unit::UI::Console::TestRunner.run(
    Kernel.const_get( 'Test' + base_klass )
  )
end

namespace :test do
  task :unit do
    #template_id = Comfy::Config.set_database( 'comfytest-unit' )
    TESTS[:unit].each { |klass| test klass, 'unit' }
  end
  
  task :functional do
    #template_id = Comfy::Config.set_database( 'comfytest-func' )
    TESTS[:functional].each { |klass| test klass, 'functional' }
  end
end
