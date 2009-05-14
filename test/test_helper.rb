require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../../lib/' )
require 'comfy'

Comfy::Config.set_database( 'comfytest-unit' )
COMFY_DB = Comfy::Config.db
