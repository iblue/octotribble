class HAMLRenderer
  def render(file)
    engine = Haml::Engine.new(file.map{|x| x}.join(""))
    [engine.render]
  end
end

Renderer.register "haml", HAMLRenderer.new
