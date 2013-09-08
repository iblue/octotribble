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

  # TODO: Add hash and cashing
  def stylesheet_link_tag(name)
    '<link href="/stylesheets/'+name+'.css" rel="stylesheet" type="text/css" />'
  end

  # TODO: Add hash and cashing
  def javascript_include_tag(name_or_path)
    unless name_or_path =~ /^http(s)?:/
      name_or_path = "/javascripts/#{name}.js"
    end
    '<script src="'+name_or_path+'" type="text/javascript"></script>'
  end

  # TODO: Add hash and cashing
  # TODO: Use opts (:width, :height, :size, ...)
  def image_tag(name, opts={})
    '<img src="/images/'+name+'" />'
  end
end

# for all markdown files, use layout.haml as layout
set :markdown, :layout_engine => :haml, :layout => :layout

get '/' do
  markdown :index
end

get '/stylesheets/*.css' do
  content_type 'text/css', :charset => 'utf-8'
  filename = params[:splat].first
  sass filename.to_sym, :views => "#{settings.root}/assets/stylesheets"
end
