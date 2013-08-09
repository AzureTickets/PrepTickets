# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{app/(.+)\.(erb|haml|slim)$}) {|m| "#{m[1]}"}
  watch(%r{app/js/(.+)\.(coffee|js)}) {|m| "#{m[1]}.js"}
  watch(%r{app/css/(.+)\.scss}) {|m| "/app.css"}
  watch(%r{app/css/(.+)\.css})
  watch(%r{app/lib/(.+\.(css|js|html|coffee|scss)).*}) { |m| "#{m[1]}" }
end
