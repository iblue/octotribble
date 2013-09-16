set :user,           "deploy"
set :group,          "deploy"

role :web, "www.yourdomain.com"
role :app, "www.yourdomain.com"
role :db,  "www.yourdomain.com", :primary => true
