class Renderer
  def call(env)
    uri = URI::parse(env["REQUEST_URI"])
    file_path = absolute_path = uri.path
    if absolute_path[-1] == "/"
      file_path += "index.html"
    elsif !(absolute_path =~ /\.[a-zA-Z0-9]+$/)
      file_path += ".html"
    end


    file_path = "./content/#{file_path}"

    if !File.exists?(file_path)
      fh = File.open("./content/404.html")
      return [404, {"Content-Type" => "text/html"}, fh]
    end

    fh = File.open(file_path)

    [200, {"Content-Type" => "text/html"}, fh]
  end
end
