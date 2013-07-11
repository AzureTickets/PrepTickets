#Used to build sprocket assets

class SprocketsBuilder
  attr_accessor :app, :root, :sprockets
  def initialize app
    self.app = app
    self.root = app.root
    self.sprockets = Sprockets::Environment.new(root) do |env|
      env.logger = app.logger
    end

    unless app.development?
      # sprockets.css_compressor = :yui
      sprockets.js_compressor = :uglifier
    end

    sprockets.append_path(root.join('js'))
    sprockets.append_path(root.join('css'))
    sprockets.append_path(root.join('lib'))
    Dir["#{root}/lib/*/"].map do |a|
      sprockets.append_path a.sub(/(\/)+$/,'')
    end
  end
end