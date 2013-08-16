@prepTickets.directive 'fillInStoreBlank', ->
  restrict: 'A' 
  scope:
    count: "=fillInStoreBlank"
  compile: (elm) ->
    (scope, element, attr) ->
      tmpl = '<div class="store blank hidden-xs col-sm-4"><i class="icon-map-marker"></i><p>No More Results</p></div>'
      # TODO: Make this more efficient, right now it's running a bunch of times
      scope.$watch "$last", ->
        angular.forEach element.parent()[0].getElementsByClassName("blank"), (blank_elm) ->
          blank_elm.remove()
        return unless scope.count
        start = parseFloat(3 - (scope.count % 3))
        start = 0 if start >= 3
        return if isNaN(start)
        console.log "inserting from ", element
        for i in [start...0]
          console.log "inserting", i
          element.after(tmpl)