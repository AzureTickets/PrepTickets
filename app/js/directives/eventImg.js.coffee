@prepTickets.directive('eventImg', () ->
  restrict: 'E' 
  replace: true
  scope:
    event: "="
    size: "@"
    target: "@"
  template: '<img img-src="{{source()}}" class="img-responsive" ng-show="event" fallback-src="{{fallbackSrc}}" alt="{{event.Name}}" title="{{event.Name}}">'
  link: (scope, element, attrs) ->
    scope.fallbackSrc = "/img/default_event.jpg"

    scope.source = ->
      return "" unless scope.event?
      return scope.fallbackSrc unless scope.target? and imgObj = scope.event?[scope.target]
      "#{imgObj.BaseURL}#{imgObj[scope.size]}"
      
    scope.$watch("event", ->
      scope.target ||= "SmallImage"
      scope.size ||= "ImageFile"
    )
)