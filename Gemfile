# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "http://rubygems.org"

# Framework, Assets and Caching
gem "sinatra"                # Framework
gem "sinatra-asset-pipeline" # Asset pipeline
gem "sinatra-outputbuffer"   # Used by my fragment cache
gem "rack-funky-cache"       # Write stuff to disk

# Renderers
gem 'redcarpet' # MarkDown renderer
gem 'haml'      # HAML renderer
gem 'sass'      # SASS stylesheet renderer

# Database
gem 'sinatra-sequel' # Sequel and bindings
gem 'sqlite3'        # Should be sufficient for ever.
gem 'rfc-822'        # Email validation

# Frontmatter
gem 'deep_merge' # For internals

# Production server
gem "unicorn"

# Deployment
gem "capistrano"

# ruby 2.0 debugger
gem 'byebug', :group => :development
