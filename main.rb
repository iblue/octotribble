require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

set :views, ['views', 'content']

register Sinatra::AssetPack

assets {
  serve '/js',     from: 'app/js'        # Default
  serve '/css',    from: 'app/css'       # Default
  serve '/images', from: 'app/images'    # Default

  # The second parameter defines where the compressed version will be served.
  # (Note: that parameter is optional, AssetPack will figure it out.)
  js :app, '/js/app.js', [
    '/js/vendor/**/*.js',
    '/js/lib/**/*.js'
  ]

  css :main, [ '/css/main.css' ]

  js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
  css_compression :sass   # :simple | :sass | :yui | :sqwish
}

helpers do
  def find_template(views, name, engine, &block)
    Array(views).each { |v| super(v, name, engine, &block) }
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
