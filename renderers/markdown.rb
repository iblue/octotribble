class MarkdownRenderer
  def render(file)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
    [markdown.render(file.map{|x| x}.join(""))]
  end
end

Renderer.register "markdown", MarkdownRenderer.new
