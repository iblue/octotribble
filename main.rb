require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

get '/hi' do
  "Hello World!"
end
