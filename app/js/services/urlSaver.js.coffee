UrlSaverService = @prepTickets.factory('UrlSaverService', ($cookieStore, $location, configService) ->
  rootUrl: ->
    url = "#{$location.protocol()}://#{$location.host()}"
    url += ":#{$location.port()}" if $location.port() isnt 80
    url
  makeAbsoluteUrl: (url) ->
    return url if url.slice(0,4).toLowerCase() is "http"
    url = url.slice(1) if url[0] is "/"
    "#{@rootUrl()}/#{url}"
  homePageUrl: ->
    @makeAbsoluteUrl("")
  save: (url=$location.path) ->
    return url unless url? and url isnt ""
    url = @makeAbsoluteUrl(url)
    console.log "saving URL:", url
    $cookieStore.put(configService.cookies.lastPath, url)
    url
  load: ->
    url = $cookieStore.get(configService.cookies.lastPath) or @homePageUrl()
    console.log "loading URL:", url
    url
)
UrlSaverService.$inject = ["cookieStore", "$location", "configService"]