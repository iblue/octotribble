require './router'

use Rack::Reloader # Reload stuff automatically (TODO: testing environment
                   # only)
run Router.new
