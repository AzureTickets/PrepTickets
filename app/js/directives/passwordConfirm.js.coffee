@prepTickets.directive('passwordConfirm', ->
  require: 'ngModel'
  link: (scope, elem, attrs, ctrl) ->
    firstPasswordField = $("##{attrs.passwordConfirm}")[0]
    check = =>
      scope.$apply(=>
        v = elem[0].value is firstPasswordField.value
        ctrl.$setValidity('passwordmatch', v)
      )

    firstPasswordField?.addEventListener('keyup', check)
    elem[0]?.addEventListener('keyup', check)
)