# Middleware that caches all pages
class Cache
  def initialize(appl)
    @appl = appl
  end

  def call(env)
    status, headers, body = @appl.call(env)

    [status, headers, body + ["<p>(went through cache middleware)</p"]]
  end
end
