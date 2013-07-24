#\ -p 8000
require './lib/application'
require "better_errors"

app = Application.new(:development)

use Rack::Reloader, 0
use BetterErrors::Middleware
use Rack::LiveReload


BetterErrors.application_root = app.project_root.to_s

Application::ASSET_DIRS.each do |dir|
  map "/#{dir}" do
    run app.sprockets
  end
end

map "/api" do
  run app.api_fetch
end
 
map "/" do
  run app.page_builder
end