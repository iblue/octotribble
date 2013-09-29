# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require './lib/asset_pipeline'
require './lib/cache'
require './lib/database'
require './lib/frontmatter'

module Octotribble
  class App < Sinatra::Base
    set :environment, ENV['RAILS_ENV'] || "development"

    # Fix rendering bugs
    Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, 'markdown', 'mkd', 'md'

    set :markdown, :renderer => Redcarpet::Render::HTML,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :layout_engine => :haml

    # Load lib
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
      # Check if there is an article or a page with that path
      page    = articles.select{|a| a["path"] == params["comment"]["page"]}[0]
      page  ||= pages.select{|a| a["path"] == params["comment"]["page"]}[0]
      status 404 and return if !page

      @comment = Comment.new(params["comment"])
      if @comment.save(:raise_on_failure => false)
        expire_page_cache(page["url"])
        redirect page["url"]+"#comment-#{@comment.id}"
      else
        @page = page["path"]
        @comments = Comment.filter(:page => @page)
        content = File.open(@page, "rb"){|f| f.read}
        markdown strip_frontmatter(content)
      end
    end

    get '/*' do
      if !article and !page
        status 404 and return
      end


      if article
        @page     = article["path"]
        @comments = Comment.filter(:page => @page)
        @comment  = Comment.new(:page => @page)
        content = File.open(@page, "rb"){|f| f.read}
        markdown strip_frontmatter(content)
      elsif page
        @page     = page["path"]
        @comments = Comment.filter(:page => @page)
        @comment  = Comment.new(:page => @page)
        content = File.open(@page, "rb"){|f| f.read}
        markdown strip_frontmatter(content)
      end
    end
  end
end
