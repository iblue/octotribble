require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

require 'rack/funky-cache'
require './octotribble.rb'

# Cache *every* get request directly to disk.
use Rack::FunkyCache, :root => Dir.pwd, :path => "/public"
run Octotribble::App
