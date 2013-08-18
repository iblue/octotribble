class Router
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["<h1>Foobar</h1>"]]
  end
end
