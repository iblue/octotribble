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
      haml :index
    end

    post '/comment' do
      # Check if there is an article with that path
      article = articles.select{|a| a["path"] == params["comment"]["page"]}[0]
      status 404 and return if !article

      @comment = Comment.new(params["comment"])
      if @comment.save
        expire_page_cache(article["url"]+".html")
        redirect article["url"]+"#comment-#{@comment.id}"
      else
        # Möp!
      end
    end

    get '/*' do
      status 404 and return if !article

      @page     = article["path"]
      @comments = Comment.filter(:page => @page)
      content = File.open(article["path"], "rb"){|f| f.read}
      markdown strip_frontmatter(content)
    end
  end
end
