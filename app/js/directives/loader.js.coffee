@prepTickets.directive('loader', () ->
  restrict: 'E' 
  replace: true
  transclude: true
  scope: 
    hideOn: "="
  template: '<div class="loading text-center" ng-hide="hideOn">
               <div class="alert alert-info"><i class="icon-spinner icon-spin icon-large"></i> <span ng-transclude></span></div>
             </div>'
)