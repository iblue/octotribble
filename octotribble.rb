require './lib/cache'
require './lib/asset_pipeline'
require './lib/database'

module Octotribble
  class App < Sinatra::Base
    register Octotribble::AssetPipeline
    register Octotribble::Cache
    register Octotribble::Database

    require './models/comment'

    set :views, ['views', 'content']

    helpers do
      def find_template(views, name, engine, &block)
        Array(views).each { |v| super(v, name, engine, &block) }
      end
    end

    # for all markdown files, use layout.haml as layout
    set :markdown, :layout_engine => :haml, :layout => :layout

    get '/' do
      @comments = Comment.filter(:page => 'index')
      markdown :index
    end

    get '/expire' do
      expire_cache("foo")
    end

    post '/comment' do
      @comment = Comment.new(params["comment"])
      if @comment.save
        expire_page_cache("index.html")
        redirect '/'
      else
        # Möp!
      end
      byebug
    end
  end
end
