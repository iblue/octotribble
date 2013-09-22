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

        def article
          articles.select{|a| a["url"] == request.path_info}[0]
        end

        def pages
          self.class.pages
        end

        def page
          pages.select{|a| a["url"] == request.path_info}[0]
        end

        def strip_frontmatter(content)
          content.sub(FRONTMATTER_REGEX, "")
        end
      end
    end

    module ClassMethods
      def read_front_matter
        @articles = read_directory('./articles', '/artikel/%y/%m')
        @articles = @articles.sort{|a,b| a["date"] <=> b["date"]}.reverse

        @pages    = read_directory('./pages')
        @pages    = @pages.sort{|a,b| a["date"] <=> b["date"]}.reverse
      end

      def read_directory(path, url_path = '')
        all_data = []

        Dir.foreach(path) do |item|
          next if item =~ /^\./
          full_path = "#{path}/#{item}"
          content = File.open("#{path}/#{item}", "rb"){|f| f.read}
          data = parse_yaml_front_matter(content)


          next if data["ignore"]

          # Use filename. slugerize strips leading date.
          slug = slugerize(item.gsub(/\..+$/, ''))

          if data["date"]
            data["date"] = Time.parse(data["date"])
            url   = data["date"].strftime(url_path) + "/#{slug}/"
          else
            url   = url_path + "/#{slug}/"
          end

          additionals = {"path" => full_path, "url" => url}
          all_data << data.deep_merge(additionals) if data
        end

        all_data
      end

      def articles
        @articles
      end

      def pages
        @pages
      end

      def parse_yaml_front_matter(content)
        if content =~ FRONTMATTER_REGEX
          YAML.load($1) || {}
        else
          false
        end
      end

      def slugerize(title)
        # strip the string
        ret = title.strip.downcase

        # blow away apostrophes
        ret.gsub! /['`]/,""

        # @ --> at, and & --> and
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "

        # Umlauts
        ret.gsub! "ä", "ae"
        ret.gsub! "ü", "ue"
        ret.gsub! "ö", "ue"
        ret.gsub! "ß", "ss"

        # replace all non alphanumeric, underscore or periods with
        # dashes
        ret.gsub! /\s*[^A-Za-z0-9\.\-_]\s*/, '-'

        # Strip leading date
        ret.gsub! /^\d{4}-\d{2}-\d{2}-/, ''

        # convert multiple dashes to single
        ret.gsub! /-+/, "-"

        # strip off leading/trailing dashes
        ret.gsub! /\A[-\.]+|[-\.]+\z/, ""

        ret
      end
    end
  end
end
