@prepTickets.directive('ticketnav', ["$location", ($location) ->
  restrict: 'E' 
  replace: true
  transclude: false
  scope: 
    order: "="
    ticket: "="
    ticketIdx: "=index"
  template: '<div class="ticketNav pagination pagination-centered pagination-large" ng-show="ticket">
              <ul>
                <li ng-class="{disabled:!hasPrevious()}">
                  <a href="" ng-click="goToPreviousTicket()">&larr; Previous Ticket</a>
                </li>
                <li ng-repeat="orderTicket in order.InventoryItems" ng-class="{active:$index==ticketIdx}">
                  <a href="" ng-href="#/orders/{{order.StoreKey}}/{{order.Key}}/{{orderTicket.Key}}">{{$index+1}}</a>
                </li>
                <li ng-class="{disabled:!hasNext()}">
                  <a href="" ng-click="goToNextTicket()">Next Ticket &rarr;</a>
                </li>
              </ul>
             </div>'
  link: (scope) ->
    scope.hasPrevious = ->
      !!scope.previousTicket()
    scope.hasNext = ->
      !!scope.nextTicket()
    scope.nextTicket = ->
      scope.order?.InventoryItems[scope.ticketIdx + 1]
    scope.previousTicket = ->
      scope.order?.InventoryItems[scope.ticketIdx - 1]
    scope.goToNextTicket = ->
      if ticket = scope.nextTicket()
        $location.path(scope.getPathFor(ticket))
    scope.goToPreviousTicket = ->
      if ticket = scope.previousTicket()
        $location.path(scope.getPathFor(ticket))
    scope.getPathFor = (ticket) ->
      "/orders/#{scope.order?.StoreKey}/#{scope.order?.Key}/#{ticket.Key}"

])