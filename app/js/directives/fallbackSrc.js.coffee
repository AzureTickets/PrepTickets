@prepTickets.directive('fallbackSrc', ->
  scope:
    fallbackSrc: "@"
  link: (scope, element, attr) ->
    if scope.fallbackSrc?
      element.addEventListener("error", ->
        angular.element(this).attr("src", scope.fallbackSrc)
      )
)