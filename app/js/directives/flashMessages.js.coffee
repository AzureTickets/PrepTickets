@prepTickets.directive('flashmessages', () ->
  restrict: 'E' 
  replace: true
  template: '<div class="flash-message hidden-print" ng-repeat="m in messages">
              <div class="alert alert-{{m.level}}">
                {{m.text}}
              </div>
            </div>'
)