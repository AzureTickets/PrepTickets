@prepTickets.directive('onKeypress', ["$compile", ($compile) ->
  restrict: 'A' 
  require: '?ngModel'
  scope:
    onKeypress: "&"
    allowEnter: "@keypressEnter"
  link: (scope, elem, attrs, ngModel) ->
    callback = (evt) ->
      scope.$apply(-> 
        scope.$eval(scope.onKeypress) if evt.keyCode isnt 13 || scope.allowEnter
      )

    elem[0]?.addEventListener('keyup', callback)
])