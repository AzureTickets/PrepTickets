cartCtrl = @prepTickets.controller "cartCtrl", ($scope, $routeParams, CartService, storeService) ->
  $scope.setupCart = ->
    $scope.CartObj = $scope.cart.getCartObj($routeParams.storeKey)
  $scope.checkout = ->
    $scope.cart.addCart($scope.CartObj)
    alert "Feature coming soon..."


cartCtrl.$inject = ["$scope", "$routeParams", "CartService", "storeService"]