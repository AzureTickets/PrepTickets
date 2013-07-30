@prepTickets.directive('loader', () ->
  restrict: 'E' 
  replace: true
  transclude: true
  scope: 
    hideOn: "="
  template: '<div class="row loading" ng-hide="hideOn">
               <div class="span4 offset3 alert text-center"><i class="icon-spinner icon-spin icon-large"></i> <span ng-transclude></span></div>
             </div>'
)