require 'test/unit/ui/console/testrunner'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/lib/' )
require 'comfy'
include Comfy

def test( klass )
  klass = klass.name.split( '::' ).last
  filename = "test/test_#{klass.downcase}.rb"
  require filename
  Test::Unit::UI::Console::TestRunner.run(Kernel.const_get('Test' + klass))
end

test Document
test Response
test Database
test Response
test View
