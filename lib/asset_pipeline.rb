require 'sinatra/asset_pipeline'

module Octotribble
  module AssetPipeline
     def self.registered(app)
      # Include these files when precompiling assets
      app.set :assets_precompile, %w(main.css *.png *.jpg *.svg *.eot *.ttf *.woff)

      # Logical path to your assets
      app.set :assets_prefix, 'assets'

      # Use another host for serving assets
      #app.set :asset_host, 'http://<id>.cloudfront.net'

      # Serve assets using this protocol
      app.set :assets_protocol, :http

      # CSS minification
      app.set :assets_css_compressor, :sass

      # JavaScript minification
      app.set :assets_js_compressor, :uglifier

      app.register Sinatra::AssetPipeline
     end
  end
end
