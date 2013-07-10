module MyTagHelper
  extend ActiveSupport::Concern  
  
  def stylesheet_tag(source, options={})
    tag("link", { "rel" => "stylesheet", "type" => "text/css", "media" => "screen", "href" => source }.merge(options), false)
  end
  def javascript_tag(source, options={})
    content_tag("script", "", { "type" => "application/javascript", "src" => source }.merge(options))
  end

  def stylesheet_link_tag name, options={}
    sources = assets_sources(name)
    links = sources.map do |s| 
      s = "#{s}?body=1" if app.development?
      stylesheet_tag(s, options)
    end
    links.join("\n")
  end

  def javascript_link_tag name, options={}
    sources = assets_sources(name)
    links = sources.map do |s| 
      s = "#{s}?body=1" if app.development?
      javascript_tag(s, options)
    end
    links.join("\n")
  end

  #######
  private
  #######
  
  def assets_sources name, options={}
    assets = app.sprockets.find_asset(name)
    return [] if assets.blank?
    extract_asset_sources_for assets
  end

  def extract_asset_sources_for(assets)
    assets_source_list = []
    if app.development?
      assets.to_a.each do |asset|
        if (asset.to_a.size > 1)
          assets_source_list + extract_asset_sources(asset)
        else
          assets_source_list << get_asset_source(asset)
        end
      end
    else
      assets_source_list << get_asset_source(assets)
    end
    assets_source_list
  end

  def get_asset_source(asset)
    return "" if asset.blank?
    asset_attr = app.sprockets.attributes_for(asset.pathname.realpath)
    name = asset_attr.logical_path.to_s
    path = asset.pathname.relative_path_from(app.root).to_s.gsub(/#{name}(.*)/, "")
    "/#{path}#{name}"
  end
  
  
end