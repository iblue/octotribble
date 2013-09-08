require 'sinatra/asset_pipeline'

class Octotribble < Sinatra::Base
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
