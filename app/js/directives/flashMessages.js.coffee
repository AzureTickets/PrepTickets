@prepTickets.directive('flashmessages', () ->
  restrict: 'E' 
  replace: true
  template: '<div ng-repeat="m in messages">
              <div class="alert alert-{{m.level}}">
                {{m.text}}
              </div>
            </div>'
)