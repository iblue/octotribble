require './lib/cache'
require './lib/asset_pipeline'

module Octotribble
  class App < Sinatra::Base
    register Octotribble::AssetPipeline
    register Octotribble::Cache

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

    get '/expire' do
      expire_cache("foo")
    end
  end
end
