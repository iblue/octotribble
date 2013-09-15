require 'sinatra/sequel'

module Octotribble
  module Frontmatter
    FRONTMATTER_REGEX = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    def self.registered(app)
      app.extend ClassMethods
      app.read_front_matter

      app.helpers do
        def articles
          self.class.articles
        end

        def strip_frontmatter(content)
          content.sub(FRONTMATTER_REGEX, "")
        end
      end
    end

    module ClassMethods
      def read_front_matter
        all_data = []
        Dir.foreach('./articles') do |item|
          next if item =~ /^\./
          full_path = "./articles/#{item}"
          content = File.open("./articles/#{item}", "rb"){|f| f.read}
          data = parse_yaml_front_matter(content)
          additionals = {"path" => full_path, "url" => "/article/#{item.gsub(/\.md$/,'')}"}
          all_data << data.deep_merge(additionals) if data
        end

        @articles = all_data
      end

      def articles
        @articles
      end

      def parse_yaml_front_matter(content)
        if content =~ FRONTMATTER_REGEX
          YAML.load($1) || {}
        else
          false
        end
      end
    end
  end
end
