cartCtrl = @prepTickets.controller "cartCtrl", ($scope, CartService, storeService) ->
  $scope.setupCart = ->
    $scope.CartObj = $scope.cart.getCartObj()
  $scope.checkout = ->
    alert "Feature coming soon..."


cartCtrl.$inject = ["$scope", "CartService", "storeService"]