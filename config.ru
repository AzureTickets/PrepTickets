#\ -p 8000
require './lib/application'

app = Application.new(:development)

use Rack::Reloader, 0

%w[/js /lib /css].each do |dir|
  map dir do
    run app.sprockets
  end
end
 
map "/" do
  run app.main_page
end