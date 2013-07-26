cartProcessedCtrl = @prepTickets.controller "cartProcessedCtrl", ($scope, $routeParams, ServerCartService) ->
  $scope.storeKey = $routeParams.storeKey
  $scope.loadServerCart = ->
    ServerCartService.initCart($routeParams.storeKey).then(
      (cart) ->
        $scope.ServerCart = cart
        $scope.checkStatus()
      (err) ->
        $scope.error.log err
    )
  $scope.checkStatus = ->
    $scope.DoneState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Done
    $scope.ErrorState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Error
    $scope.CanceledState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Canceled
    $scope.PaidState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Paid
    $scope.ProcessingState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Processing
    $scope.PendingState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Pending
    $scope.OpenState = $scope.ServerCart.State is BWL.Models.CartStateEnum.Open
    $scope.UnprocessedState = $scope.ServerCart.State <= BWL.Models.CartStateEnum.New

    if $scope.ServerCart.State >= BWL.Models.CartStateEnum.Paid
      $scope.cart.clear($routeParams.storeKey)


cartProcessedCtrl.$inject = ["$scope", "$routeParams", "ServerCartService"]