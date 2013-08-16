@prepTickets.directive('blocks', () ->
  restrict: 'E' 
  replace: true
  transclude: true
  scope: {}
  template: '<div class="row blocks row-unpadded" ng-transclude>
             </div>'
)