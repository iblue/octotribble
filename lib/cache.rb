module Octotribble
  module Cache
    def self.registered(app)
      app.register Sinatra::OutputBuffer # For cache
      app.set :cache_path, 'cache'

      app.helpers do
        def cache(key, &block)
          output = read_entry(key)
          if !output
            output = capture_html(&block)
            write_entry(key, output)
          end
          concat_content(output)
        end

        def expire_cache(key)
          delete_entry(key)
        end

        def write_entry(key, content)
          atomic_write(cache_file_name(key)) do |f|
            Marshal.dump(content, f)
          end
        end

        def read_entry(key)
          file_name = cache_file_name(key)

          if File.exist?(file_name)
            File.open(file_name) { |f| Marshal.load(f) }
          end
        end

        def delete_entry(key)
          file_name = cache_file_name(key)
          if File.exist?(file_name)
            begin
              File.delete(file_name)
              true
            rescue => e
              # Just in case the error was caused by another process
              # deleting the file first.
              raise e if File.exist?(file_name)
              false
            end
          end
        end

        def atomic_write(file_name)
          temp_dir = File.join(settings.root, "tmp")
          FileUtils.mkdir_p(temp_dir)
          temp_file = Tempfile.new("." + File.basename(file_name), temp_dir)
          yield temp_file
          temp_file.close
          File.rename(temp_file.path, file_name)
        end

        def cache_file_name(key)
          File.join(settings.root, 'cache', key)
        end
      end
    end
  end
end
