require 'lib/view_context'

class PageBuilder
  
  DEBUG_VARS = %w(root status page_exists? file_name extension engines )

  attr_reader :app, :root, :env

  def view_context_class
    @view_context_class ||= ViewContext.new(self)
  end

  def initialize(app, target_page=nil)
    @app = app
    @target_page = target_page
  end

  def root
    app.root
  end



  def render_to_string
    file = File.read(page_path)
    file = process_template(page_path.to_s) if engines.include?("erb") || is_404_error? 
    file
  end

  def call(env) #Rack calls this automagically
    new_request! env
    [
      status,
      {
        'Content-Type'  => content_type,
        'Cache-Control' => 'public, max-age=86400'
      },
      [render_to_string]
    ]
  end

  def to_s    
    result = []
    DEBUG_VARS.each do |attr| 
      result << "#{attr.upcase} = #{eval(attr)}"
    end
    result.join("\n")
  end
  def inspect
    to_s
  end

  def file_name
    if env
      @file_name ||= (env["REQUEST_PATH"] == "/" ? app.root_page : env["REQUEST_PATH"]).to_s.gsub(/^\//, '')
    else
      @target_page.relative_path_from(root).to_s
    end
  end
  
  #######
  private
  #######

  def new_request! env
    @env = env
    @real_path = nil
    @file_name = nil
  end

  def status
    return 404 unless page_exists?
    200
  end
  def page_path
    real_path
  end

  def real_path
    @real_path ||= find_file(file_name)
  end

  

  def find_file(file_name)
    file = Dir.glob("#{root.join(file_name)}*").first
    if file
      Pathname(file).realpath.tap do |file|
        @file_name = file.basename
      end
    else
      Pathname(four_o_four).realpath
    end
  rescue Errno::ENOENT => ex
    app.logger.warn "EXCPETION: #{ex}"
    raise ex
  end

  def page_exists?
    real_path != four_o_four
  end
  def is_404_error?
    !page_exists?
  end

  def content_type
    return "text/html" unless page_exists?
    case extension
    when "json"
      "application/json"
    when "png", "gif", "jpg"
      "image/#{extension}"
    else 
      "text/html"
    end
  end
  def extension
    split_file_name[1] || "html"
  end

  def engines
    split_file_name[2, split_file_name.length] || []
  end
  def split_file_name
    file_name.to_s.split(".")
  end

  def four_o_four
    root.join(app.four_o_four)
  end

  def process_template(file_name)
    Tilt.new(file_name).render(view_context_class)
  end

end
