@prepTickets.directive('storeImg', () ->
  restrict: 'E' 
  replace: true
  scope:
    store: "="
    size: "@"
    target: "@"
  template: '<img img-src="{{source()}}" class="img-responsive" ng-show="store" fallback-src="{{fallbackSrc}}" alt="{{store.Name}}" title="{{store.Name}}">'
  link: (scope, element, attrs) ->
    scope.fallbackSrc = "/img/default_store.jpg"

    scope.source = ->
      return "" unless scope.store?
      return scope.fallbackSrc unless scope.target? and imgObj = scope.store?[scope.target]
      "#{imgObj.BaseURL}#{imgObj[scope.size]}"
      
    scope.$watch("store", ->
      scope.target ||= "SmallImage"
      scope.size ||= "ImageFile"
    )
)