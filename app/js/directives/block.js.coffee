@prepTickets.directive('block', () ->
  restrict: 'E' 
  replace: true
  transclude: true
  scope: true
  template: '<div class="block col-sm-4" ng-transclude></div>'
  link: (scope, element, attrs) ->
    buildClasses = (type, color) ->
      arr = []
      arr.push("block-#{type}") if type?
      arr.push("block-point-right") if type is "target"
      arr.push("no-overflow") if type is "image"
      if color?
        arr.push("#{color}-bg") 
        arr.push("dark-#{color}-font") 
      arr.join(" ")
    element.addClass(buildClasses(attrs.type, attrs.color))
)