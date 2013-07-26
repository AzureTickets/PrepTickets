cartCtrl = @prepTickets.controller "cartCtrl", ($scope, $routeParams, $location, flash, CartService, storeService) ->
  $scope.setupCart = ->
    $scope.CartObj = $scope.cart.getCartObj($routeParams.storeKey)
  $scope.clearCart = ->
    flash('Cart has been cleared') if $scope.cart.clearCart()
    $location.path("/")
  $scope.checkout = ->
    $scope.cart.replaceCart($scope.CartObj)
    storeService.clearStore()
    alert "Feature coming soon..."


cartCtrl.$inject = ["$scope", "$routeParams", "$location", "flash", "CartService", "storeService"]