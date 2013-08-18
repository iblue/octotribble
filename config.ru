if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

require './cache'
require './renderer'

use Rack::Reloader # Reload stuff automatically (TODO: testing environment
                   # only)
use Cache
run Renderer.new
