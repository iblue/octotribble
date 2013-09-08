require 'sinatra/asset_pipeline'

class Octotribble < Sinatra::Base
   # Include these files when precompiling assets
  set :assets_precompile, %w(main.css *.png *.jpg *.svg *.eot *.ttf *.woff)

  # Logical path to your assets
  set :assets_prefix, 'assets'

  # Use another host for serving assets
  #set :asset_host, 'http://<id>.cloudfront.net'

  # Serve assets using this protocol
  set :assets_protocol, :http

  # CSS minification
  set :assets_css_compressor, :sass

  # JavaScript minification
  set :assets_js_compressor, :uglifier

  register Sinatra::AssetPipeline

  set :views, ['views', 'content']

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
end
