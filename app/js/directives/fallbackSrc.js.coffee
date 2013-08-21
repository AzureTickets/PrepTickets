@prepTickets.directive('fallbackSrc', ->
  scope:
    fallbackSrc: "@"
    imgSrc: "@"
  controller: ["$scope", "$element", "$attrs", (scope, element, attr) ->
    loadElement = angular.element(document.createElement('img'))
    loadImage = -> element.attr('src', loadElement.attr('src'))

    loadElement.bind('error', ->
      scope.$apply( -> 
        console.log "Error loading image: ", element
        element.attr("src", scope.fallbackSrc) if scope.fallbackSrc?
      )
    )

    loadElement.bind('load', loadImage)
    loadElement.bind('onload', loadImage)

    scope.$watch("imgSrc", ->
      loadElement.attr('src', if scope.imgSrc? then scope.imgSrc else attr.src)
    )
  ]
)