orderCtrl = @prepTickets.controller('orderCtrl', ($scope, $location, $routeParams, $q, $window, $timeout, OrderService) ->
  $scope.ReceiptPrint = false
  findTicket = (key) ->
    return [-1, {}] unless $scope.Order?.Key
    for ticket, idx in $scope.Order.InventoryItems
      return [idx, ticket] if ticket.Key is key
    [-1, {}]

  $scope.EventData = {}
  $scope.loadOrders = ->
    OrderService.getAll().then(
      (orders) ->
        $scope.Orders = orders
        $scope.breadcrumbs.addOrders()
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
            $scope.root.title = "Order ##{order.OrderId}"
            $scope.breadcrumbs.addOrder(order)
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
          $scope.loadEventForTicket($scope.Ticket)
          $scope.breadcrumbs.addTicket($scope.Order, $scope.Ticket, $scope.TicketIdx + 1)
          $scope.root.title = "Ticket ##{result[0] + 1} for Order ##{$scope.Order.OrderId}"
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
  $scope.loadEventForTicket = (ticket) ->
    return null unless ticket?
    $scope.loadEvent(ticket.StoreKey, ticket.EventKey).then(
      (event) -> $scope.EventData[event.Key] = event
      (err) -> $scope.error.log err
    )

  $scope.printTicket = ->
    $window.print()

  $scope.printReceipt = ->
    $scope.ReceiptPrint = true
    $timeout 
      ->
        $window.print()
        $scope.ReceiptPrint = false
      100


)
orderCtrl.$inject = ["$scope", "$location", "$routeParams", "$q", "$window", "$timeout", "OrderService"]