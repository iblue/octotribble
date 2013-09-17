require 'sinatra/sequel'

module Octotribble
  module Database
    def self.registered(app)
      app.register Sinatra::SequelExtension

      app.set :database, "sqlite://db/#{app.settings.environment}.db"

      # Make sure comments exist
      app.migration "create comments" do
        app.database.create_table :comments do
          primary_key :id
          string      :page,         :null => false
          text        :content,      :null => false
          string      :author_name,  :null => false
          string      :author_email, :null => false
          string      :author_url
          timestamp   :created_at,   :null => false

          index [:id, :page], :unique => true
        end
      end
    end
  end
end
