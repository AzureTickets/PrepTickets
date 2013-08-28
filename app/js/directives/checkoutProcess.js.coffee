@prepTickets.directive('checkoutProcess', () ->
  restrict: 'E' 
  replace: true
  scope: {}
  template: ' <div class="row row-unpadded checkout-process">
                <checkout-step current="{{step}}" target="1">
                  {{"CheckoutProcess.Step1" | t:"Choose Ticket Type"}}
                </checkout-step>
                <checkout-step current="{{step}}" target="2">
                  {{"CheckoutProcess.Step2" | t:"Confirm Order"}}
                </checkout-step>
                <checkout-step current="{{step}}" target="3">
                  {{"CheckoutProcess.Step3" | t:"Checkout"}}
                </checkout-step>
              </div>'
  link: (scope, element, attrs) ->
    scope.step = attrs.step
)