require './cache'
require './router'

use Rack::Reloader # Reload stuff automatically (TODO: testing environment
                   # only)
use Cache
run Router.new
