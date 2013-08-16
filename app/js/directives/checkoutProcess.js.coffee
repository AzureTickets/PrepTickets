@prepTickets.directive('checkoutProcess', () ->
  restrict: 'E' 
  replace: true
  scope: {}
  template: ' <div class="row row-unpadded checkout-process">
                <checkout-step current="{{step}}" target="1">
                  Choose Ticket Type
                </checkout-step>
                <checkout-step current="{{step}}" target="2">
                  Confirm Order
                </checkout-step>
                <checkout-step current="{{step}}" target="3">
                  Checkout
                </checkout-step>
              </div>'
  link: (scope, element, attrs) ->
    console.log attrs.step
    scope.step = attrs.step
)