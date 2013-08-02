orderCtrl = @prepTickets.controller('orderCtrl', ($scope, $location, $routeParams, $q, $window, OrderService) ->
  findTicket = (key) ->
    return [-1, {}] unless $scope.Order?.Key
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
    $scope.store.getStore($routeParams.storeKey).then(
      (store) ->
        $scope.StoreObj = store
        OrderService.get($routeParams.storeKey, $routeParams.orderKey).then(
          (order) ->
            $scope.Order = order if order.Key
          (err) ->
            $scope.error.log err
        )
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
          $scope.TicketIdx = result[0]
          $scope.Ticket = result[1]
          $scope.loadEvent($scope.Ticket.StoreKey, $scope.Ticket.EventKey).then(
            (event) ->
              console.log event
              $scope.Event = event
            (err) ->
              $scope.error.log err
          )
        (err) ->
          $scope.error.log err
      )

    def.promise


  $scope.loadEvent = (storeKey, eventKey) ->
    def = $q.defer()
    $scope.store.getStore(storeKey).then(
      (store) ->
        for event in store.Events
          if event.Key is eventKey
            def.resolve(event)
            break
      (err) ->
        def.reject(err)
    )
    def.promise

  $scope.printTicket = ->
    $window.print()

)
orderCtrl.$inject = ["$scope", "$location", "$routeParams", "$q", "$window", "OrderService"]