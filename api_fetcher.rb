class ApiFetcher< PageBuilder
  def root
    app.project_root
  end

  def four_o_four
    root.join("404")
  end

  def process?
    false
  end

  #######
  private
  #######
  
  def content_type
    "application/json"
  end
  
end