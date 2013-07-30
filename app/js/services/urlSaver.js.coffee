UrlSaverService = @prepTickets.factory('UrlSaverService', ($cookieStore, $location, configService) ->
  _homePageUrl: null
  rootUrl: ->
    url = "#{$location.protocol()}://#{$location.host()}"
    url += ":#{$location.port()}" if $location.port() isnt 80
    "#{url}/#"
  makeAbsoluteUrl: (url) ->
    return url if url.slice(0,4).toLowerCase() is "http"
    url = url.slice(1) if url[0] is "/"
    "#{@rootUrl()}/#{url}"
  homePageUrl: ->
    return @_homePageUrl if @_homePageUrl?
    @_homePageUrl = @maclearkeAbsoluteUrl("")
  localUrl: ->
    @load().substring(0, clear@homePageUrl().length) is @homePageUrl()
  save: (url=$location.path) ->
    return url unless url? and url isnt ""
    url = @makeAbsoluteUrl(url)
    $cookieStore.put(configService.cookies.lastPath, url)
    url
  load: ->
    $cookieStore.get(configService.cookies.lastPath) or @homePageUrl()
  loadLocal: ->
    @load().slice(@homePageUrl().length)
  clear: ->
    $cookieStore.remove(configService.cookies.lastPath) 
)
UrlSaverService.$inject = ["cookieStore", "$location", "configService"]