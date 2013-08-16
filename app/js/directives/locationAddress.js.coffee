@prepTickets.directive('locationAddress', [() ->
  restrict: 'E' 
  scope:
    address: "&"
  replace: true
  transclude: true
  template: ' <div class="row location">
                <div class="col-xs-3 map-marker"><i class="icon-map-marker icon-large"></i></div>
                <div class="col-xs-9"><address ng-transclude></address></div>
              </div>'    
])