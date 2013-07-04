require './lib/application'

namespace :build do
  desc "[internal] Setup application"
  task :setup do
    @app = Application.new(:production)

    Dir.mkdir(@app.build_root) unless File.exists?(@app.build_root)
  end

  desc "[internal] Clear build folder"
  task :clear_build => :setup do
    if File.exists?(@app.build_root)
      @app.logger.info "Clearing Build Directory..."
      FileUtils.rm_rf(@app.build_root) 
    end
  end

  desc "Render asset files for production"
  task :assets => :setup do
    @app.logger.info "Building Assets..."

    Application::ROOT_ASSETS.each do |bundle|
      assets = @app.sprockets.find_asset(bundle)

      prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
      FileUtils.mkpath @app.build_root.join(prefix)

      realname = assets.pathname.basename.to_s.split(".")[0..1].join(".")
      File.open("#{@app.build_root.join(prefix, realname)}", 'wb') do |f|
        f.write assets.to_s
      end
    end
  end

  desc "Render html files"
  task :html => :setup do
    @app.logger.info "Building html..."
    pages = @app.root.entries.select{|i| i.basename.to_s =~ /(.+).html(.*)/ }
    pages.each do |page|
      case page.to_s
      when /.html.erb$/
        filename = page.basename.to_s.split(".")[0..1].join('.')
        @app.logger.debug "  Rendering and Copying #{filename} to build folder"
        page_builder = PageBuilder.new(@app, @app.root.join(page.basename))
        File.open(@app.build_root.join(filename), 'wb') {|f| f.write(page_builder.render_to_string) }
      else
        @app.logger.debug "  Copying #{page.basename} to build folder"
        FileUtils.cp(@app.root.join(page.basename), @app.build_root.join(page.basename))
      end
    end
  end

  desc "Copies the rest of the data in the app folder"
  task :move_rest => :setup do
    @app.logger.info "Moving rest of the files to build directory..."
    @app.root.each_child do |i|
      #only move dirs that aren't part of the rendered assets dirs
      unless i.file? || Application::ASSET_DIRS.include?(i.basename.to_s) 
        @app.logger.debug "  Moving #{i.basename}"
        FileUtils.cp_r(@app.root.join(i), @app.build_root)
      end
    end
  end
end # of namespace

desc "Render all files for production"
task :build => ["build:clear_build", "build:assets", "build:html", "build:move_rest"]

task :default => :build