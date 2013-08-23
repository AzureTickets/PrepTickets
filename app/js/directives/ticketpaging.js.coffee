@prepTickets.directive('ticketpaging', ["$location", ($location) ->
  restrict: 'E' 
  replace: true
  transclude: false
  scope: 
    order: "="
    ticket: "="
    ticketIdx: "=index"
  template: '<div class="ticketNav hidden-print" ng-show="ticket">
              <ul class="pagination">
                <li ng-class="{disabled:!hasPrevious()}">
                  <a href="" ng-click="goToPreviousTicket()">&larr; {{"Ticket.Button.PreviousTicket" | t:"Previous Ticket"}}</a>
                </li>
                <li ng-repeat="orderTicket in order.InventoryItems" ng-class="{active:$index==ticketIdx}">
                  <a href="" ng-href="#/orders/{{order.StoreKey}}/{{order.Key}}/{{orderTicket.Key}}">{{$index+1}}</a>
                </li>
                <li ng-class="{disabled:!hasNext()}">
                  <a href="" ng-click="goToNextTicket()">{{"Ticket.Button.NextTicket" | t:"Next Ticket"}} &rarr;</a>
                </li>
              </ul>
             </div>'
  link: (scope) ->
    scope.ready = ->
      scope.ticketIdx? and scope.order?
    scope.hasPrevious = ->
      !!scope.previousTicket()
    scope.hasNext = ->
      !!scope.nextTicket()
    scope.nextTicket = ->
      return null unless scope.ready()
      scope.order?.InventoryItems[scope.ticketIdx + 1]
    scope.previousTicket = ->
      return null unless scope.ready()
      scope.order?.InventoryItems[scope.ticketIdx - 1]
    scope.goToNextTicket = ->
      $location.path(scope.getPathFor(ticket)) if ticket = scope.nextTicket()
    scope.goToPreviousTicket = ->
      $location.path(scope.getPathFor(ticket)) if ticket = scope.previousTicket()
    scope.getPathFor = (ticket) ->
      "/orders/#{scope.order?.StoreKey}/#{scope.order?.Key}/#{ticket.Key}"

])