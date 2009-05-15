require 'test/unit'
require 'redgreen'
$:.unshift( File.dirname( File.expand_path( __FILE__ ) ) + '/../../lib/' )
require 'comfy'

# if you aren't using autotest, comment this and uncomment
# the similar lines in Rakefile
COMFY_DB = Comfy::Config.set_database( 'comfytest' )
