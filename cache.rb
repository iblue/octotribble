# Middleware that caches all pages
class Cache
  def initialize(appl)
    @appl = appl
  end

  def call(env)
    uri = URI::parse(env["REQUEST_URI"])
    file_path = absolute_path = uri.path
    if absolute_path[-1] == "/"
      file_path += "index.html"
    end

    file_path = "./public/#{file_path}"

    if File.exists?(file_path)
      fh = File.open(file_path)
      return [200, {"Content-Type" => "text/html", "X-From-Cache" => "true"}, fh]
    end


    status, headers, body = @appl.call(env)

    if status == 200 && !File.exists?(file_path)
      File.open(file_path, "w") do |fh|
        fh.write body.join("")
        fh.close
      end
    end

    [status, headers, body]
  end
end
