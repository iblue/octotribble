class Renderer
  def call(env)
    file_path = file_path_from_request_uri(env["REQUEST_URI"])
    render_this = search_matching_file(file_path)

    if !render_this
      fh = File.open("./content/404.html")
      return [404, {"Content-Type" => "text/html"}, fh]
    end

    [200, {"Content-Type" => "text/html"}, render(render_this)]
  end

  def self.register(extention, klass)
    @@renderers ||= {}
    @@renderers[extention] = klass
  end

  private
  def file_path_from_request_uri(uri)
    absolute_path = URI::parse(uri).path

    # Separate directory and file
    if (match = absolute_path.match(/\A(.*)\/(.*)\Z/))
      directory, file = match[1], match[2]
    else
      raise "Could not parse path"
    end

    # Remove extention
    if (match = file.match(/\A([^.]*)\.(.*)\Z/))
      file = match[1]
      extention = match[2]
    end

    if file == ""
      file = "index"
    end

    [directory, file, extention]
  end

  def search_matching_file(path)
    directory, file, _ = path

    @@renderers.keys.each do |ext|
      path = "./content/"+directory+"/"+file+"."+ext
      return path if File.exists?(path)
    end

    return nil
  end

  def render(file)
    _, _, ext = file.rpartition(".")

    fh = File.open(file)

    if !@@renderers[ext]
      raise "Don't know how to render this"
    end

    @@renderers[ext].render(fh)
  end
end

Dir["./renderers/*.rb"].each{|file| require file}
