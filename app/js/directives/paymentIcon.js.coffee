@prepTickets.directive('paymentIcons', () ->
  restrict: 'E' 
  replace: true
  scope:
    paymentProvider: "@"
  template: '<img img-src="{{imageSrc}}" fallback-src="/img/payments/default_payment.png" class="img-responsive payment-icons" alt="Payment Options" title="Payment Options"/>'
  link: (scope, element, attrs) ->
    scope.$watch("paymentProvider", (newValue) ->
      scope.imageSrc = "/img/payments/#{newValue.toLowerCase()}.png" if newValue and newValue isnt ""
    )
)