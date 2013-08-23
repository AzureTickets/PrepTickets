@prepTickets.directive('storeImg', () ->
  restrict: 'E' 
  replace: true
  scope:
    store: "="
    alt: "@"
    size: "@"
    target: "@"
  template: '<img img-src="{{source()}}" class="img-responsive" ng-show="store" fallback-src="{{fallbackSrc}}" alt="{{alt}}">'
  link: (scope, element, attrs) ->
    scope.fallbackSrc = "/img/default_store.jpg"
    
    scope.source = ->
      console.log "CHecking: #{scope.target} and #{scope.store?[scope.target]}"
      return "" unless scope.target? and imgObj = scope.store?[scope.target]
      console.log "src is: #{imgObj.BaseURL}#{imgObj[scope.size]}"
      "#{imgObj.BaseURL}#{imgObj[scope.size]}"
    scope.$watch("store", ->
      scope.target ||= "SmallImage"
      scope.size ||= "ImageFile"
      console.log "Store was set now", scope.store, scope.target, scope.size
    )
)