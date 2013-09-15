require './lib/asset_pipeline'
require './lib/cache'
require './lib/database'
require './lib/frontmatter'

module Octotribble
  class App < Sinatra::Base
    register Octotribble::AssetPipeline
    register Octotribble::Cache
    register Octotribble::Database
    register Octotribble::Frontmatter

    require './models/comment'

    set :views, ['views', 'content']

    helpers do
      def find_template(views, name, engine, &block)
        Array(views).each { |v| super(v, name, engine, &block) }
      end

      def link_to(title, url)
        '<a href="'+url+'">'+title+'</a>'
      end
    end

    # for all markdown files, use layout.haml as layout
    set :markdown, :layout_engine => :haml, :layout => :layout

    get '/' do
      @comments = Comment.filter(:page => 'index')
      haml :index
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
    end
  end
end
