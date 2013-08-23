#Used to build sprocket assets

class SprocketsBuilder
  attr_accessor :app, :root, :sprockets
  def initialize app
    self.app = app
    self.root = app.root
    self.sprockets = Sprockets::Environment.new(root) do |env|
      env.logger = app.logger
    end

    sprockets.context_class.class_eval do
      def asset_path(path, options = {})

        case options[:type].to_sym
        when :font
          "/font/#{path}"
        else
          logger.debug "NOTE::: looking up #{path} with #{options}"
          "/#{options[:type]}/#{path}"
        end
      end
    end

    if app.development?
      #Cache the css/js
      sprockets.cache = Sprockets::Cache::FileStore.new(app.project_root.join("tmp").to_s)
    else
      # sprockets.css_compressor = :yui
      sprockets.js_compressor = Uglifier.new(mangle: false)
    end

    sprockets.append_path(root.join('js'))
    sprockets.append_path(root.join('css'))
    sprockets.append_path(root.join('lib'))

    Dir["#{root}/lib/*/"].map do |a|
      sprockets.append_path a.sub(/(\/)+$/,'')
    end
  end
end