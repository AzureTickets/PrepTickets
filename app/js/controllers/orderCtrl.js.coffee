orderCtrl = @prepTickets.controller('orderCtrl', ($scope, $location, $routeParams, $q, OrderService) ->
  findTicket = (key) ->
    return [-1, {}] unless $scope.Order?
    for ticket, idx in $scope.Order.InventoryItems
      return [idx, ticket] if ticket.Key is key
    [-1, {}]

  $scope.loadOrders = ->
    OrderService.getAll().then(
      (orders) ->
        $scope.Orders = orders
      (err) ->
        $scope.error.log err
    )
  $scope.loadOrder = ->
    OrderService.get($routeParams.storeKey, $routeParams.orderKey).then(
      (order) ->
        console.log order
        $scope.Order = order
      (err) ->
        $scope.error.log err
    )
  $scope.loadTicket = ->
    def = $q.defer()

    if $scope.Ticket?.Key is $routeParams.ticketKey
      def.resolve($scope.Ticket)
    else
      $scope.loadOrder().then(
        (order) ->
          result = findTicket($routeParams.ticketKey)
          console.log result
          $scope.TicketIdx = result[0]
          $scope.Ticket = result[1]
        (err) ->
          $scope.error.log err
      )

    def.promise




)
orderCtrl.$inject = ["$scope", "$location", "$routeParams", "$q", "OrderService"]