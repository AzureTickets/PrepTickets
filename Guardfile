# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml|slim)$})
  watch(%r{app/js/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{app(/(js|css|lib)/\w+/(.+\.(css|js|html|coffee|scss))).*}) { |m| "#{m[1]}" }
end
