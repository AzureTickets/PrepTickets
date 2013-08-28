@prepTickets.directive('addthisToolbox', ["$timeout", ($timeout) ->
  restrict: 'A'
  transclude: true
  replace: true
  scope:
    waitTill: "="
  template: '<div ng-transclude></div>',
  link: (scope, element, attrs) ->
    scope.$watch("waitTill", (newValue) ->
      if newValue and newValue isnt ""
        addthis.init()
        addthis.toolbox(element[0])
    )
])