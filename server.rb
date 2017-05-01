require "sinatra"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}
