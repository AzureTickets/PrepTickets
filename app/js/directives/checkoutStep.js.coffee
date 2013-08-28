@prepTickets.directive('checkoutStep', () ->
  restrict: 'E'
  replace: true
  transclude: true
  scope: 
    current: "@"
    target: "@"
  template: ' <div class="process-step col-sm-4" ng-class="{active:currentStep(), passed:passStep(), upcoming:futureStep(), \'hidden-xs\':!currentStep(), \'block-point-right\':current != 3}">
                <div class="info">
                  <span ng-show="nextStep()">{{"CheckoutProcess.NextStep" | t:"Next Step"}}</span>
                  <span ng-show="currentStep()">{{"CheckoutProcess.StepCount" | t:({defaultValue:"Step " + target + " of 3", number: target, total: 3})}}</span>
                </div>
                <span class="badge">{{target}}</span>
                <span ng-transclude class="text"></span>
              </div>'
  link: (scope, element, attrs) ->
    scope.total = 3
    scope.passStep = () ->
      scope.current > scope.target
    scope.nextStep = () ->
      (parseInt(scope.current) + 1) is parseInt(scope.target)
    scope.currentStep = () ->
      scope.current is scope.target
    scope.futureStep = () ->
      scope.current < scope.target
    scope.finalStep = () ->
      scope.current is scope.total
)