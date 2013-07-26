orderCtrl = @prepTickets.controller('orderCtrl', ($scope, $location, $routeParams, OrderService) ->
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
)
orderCtrl.$inject = ["$scope", "$location", "$routeParams", "OrderService"]