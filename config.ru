if ENV['RACK_ENV'] = 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

require './cache'
require './router'

use Rack::Reloader # Reload stuff automatically (TODO: testing environment
                   # only)
use Cache
run Router.new
