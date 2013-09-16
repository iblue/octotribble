require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

require './octotribble.rb'

# rake asset:precompile
require 'sinatra/asset_pipeline/task.rb'
Sinatra::AssetPipeline::Task.define! Octotribble::App
