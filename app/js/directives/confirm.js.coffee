@prepTickets.directive('confirm', ["$compile", "ModalService", ($compile, ModalService) ->
  priority: 1
  terminal: true
  link: (scope, element, attr) ->
    msg = attr.confirm || "Are you sure?"
    $compile(element.contents())(scope.$new())
    clickAction = attr.ngClick;
    element.bind('click', (e) ->
      e.preventDefault()
      scope.$apply(scope.$eval(clickAction)) if ModalService.confirm(msg)
    )
])