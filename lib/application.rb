$LOAD_PATH << '.'
$LOAD_PATH << './lib'

require 'sprockets_builder'
require 'page_builder'
require 'logger'
require 'forwardable'

Bundler.require

class Application
  extend Forwardable

  APP_DIR = "app"
  APP_PAGE = "index.html"
  ERROR_404_PAGE = "404.html.erb"
  BUILD_DIR = "build"
  ROOT_ASSETS = %w( app.css main.js BWL.js)
  ASSET_DIRS = %w( js css lib )
  TEMPLATE_DIR = "#{APP_DIR}/templates"

  attr_accessor :env

  def initialize (env=:development)
    self.env = env
  end
  
  %w(development production).each do |env_name|
    define_method("#{env_name}?") do 
      self.env.to_s.downcase == env_name
    end
  end
  
  class << self #Class methods
    def root
      @root ||= project_root.join(APP_DIR).realpath
    end
    def project_root
      @project_root ||= Pathname(File.dirname(__FILE__)).parent.realpath
    end
    def build_root
      @build_root ||= project_root.join(BUILD_DIR).realdirpath
    end
    def logger
      @logger ||= Logger.new(STDOUT)
    end
    def root_page
      APP_PAGE
    end
    def four_o_four
      ERROR_404_PAGE
    end
  end # of class methods
  
  def_delegators self, 
                 :root, 
                 :project_root, 
                 :build_root, 
                 :logger, 
                 :root_page, 
                 :four_o_four

  def root_assets
    self.class::ROOT_ASSETS
  end

  def sprockets
    @sprockets ||= SprocketsBuilder.new(self).sprockets
  end
  def page_builder
    @page ||= PageBuilder.new(self)
  end
end
