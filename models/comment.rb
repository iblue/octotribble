require 'digest/md5'

class Comment < Sequel::Model
  def validate
    self.author_url = nil if (author_url && author_url.strip == "")
    self.created_at ||= Time.now
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest(author_email.downcase)
    "http://www.gravatar.com/avatar/#{hash}.jpg?d=mm&s=70"
  end
end
