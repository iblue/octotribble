require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

set :views, ['views', 'content']

helpers do
  def find_template(views, name, engine, &block)
    Array(views).each { |v| super(v, name, engine, &block) }
  end
end

# for all markdown files, use post.haml as layout
set :markdown, :layout_engine => :haml, :layout => :post

get '/' do
  markdown :index
end
