#
# Looks up image for a given object
#
@prepTickets.filter('image', () ->
  defaultFallbackSrc = "/img/default_store.jpg"
  buildImageString = (imageObj, options={}) ->
    "<img ng-src=\"#{imageObj.BaseURL}#{imageObj[options.size || "ImageFile"]}\" fallback-src=\"#{options.fallbackSrc || defaultFallbackSrc}\" alt=\"#{options.name || ''}\">"

  (obj, options={}) ->
    console.log "Image builder", obj, options unless obj?
    return "" unless obj?
    if typeof options is "string"
      target = options
      options = {}
      options.target = target
    options.size ||= "ImageFile" 
    imageObj = obj[options.target]
    console.log imageObj, buildImageString(imageObj, options)
    return "" unless imageObj
    buildImageString(imageObj, options)
)