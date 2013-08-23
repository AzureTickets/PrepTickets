@prepTickets.directive('fallbackSrc', ->
  controller: ["$scope", "$element", "$attrs", (scope, element, attr) ->
    loadElement = angular.element(document.createElement('img'))
    loadImage = -> element.attr('src', loadElement.attr('src'))

    loadElement.bind('error', ->
      scope.$apply( -> 
        console.log "Error loading image: ", element.src
        element.attr("src", attr.fallbackSrc) if attr.fallbackSrc?
      )
    )

    loadElement.bind('load', loadImage)
    loadElement.bind('onload', loadImage)

    scope.$watch(
      ->
        return (attr.imgSrc isnt undefined and attr.imgSrc isnt "") or (attr.src isnt undefined and attr.src isnt "")
      (cont) ->
        return unless cont
        loadElement.attr('src', if attr.imgSrc? then attr.imgSrc else attr.src)
    )
  ]
)