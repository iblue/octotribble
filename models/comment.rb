class Comment < Sequel::Model
  def validate
    self.created_at ||= Time.now
  end
end
