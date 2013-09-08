module Octotribble
  module Cache
    def self.registered(app)
      app.register Sinatra::OutputBuffer # For cache
      app.set :cache_path, 'cache'

      app.helpers do
        def cache(key, &block)
          @@cache ||= {}
          @@cache[key] = capture_html(&block) if !@@cache[key]
          concat_content(@@cache[key])
        end

        def expire_cache(key)
          @@cache ||= {}
          @@cache.delete key
        end
      end
    end
  end
end
