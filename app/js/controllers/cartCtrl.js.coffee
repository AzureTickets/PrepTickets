cartCtrl = @prepTickets.controller "cartCtrl", ($scope, $routeParams, $location, $window, flash, ServerCartService, storeService, UrlSaverService) ->
  $scope.$on "ServerCart:Uploaded", ->
    $location.path("cart/#{$routeParams.storeKey}/confirm")
  $scope.setupCart = ->
    $scope.CartObj = $scope.cart.getCartObj($routeParams.storeKey)
  $scope.clearCart = ->
    flash('Cart has been cleared') if $scope.cart.clear($routeParams.storeKey)
    $location.path("/")
  $scope.checkout = ->
    $scope.cart.replaceCart($scope.CartObj)
    if $scope.auth.isSignedIn()
      $scope.cart.sendToServer() #once completed, it will fire ServerCart:Uploaded event
    else
      flash(BWL.t("Signin.Required", defaultValue: "You must sign in or sign up before you can continue"))
      UrlSaverService.save("cart/#{$routeParams.storeKey}/instantCheckout")
      $location.path("signin")

  $scope.instantCheckout = ->
    $scope.setupCart()
    $scope.cart.sendToServer() #once completed, it will fire ServerCart:Uploaded event

  $scope.removeItem = (key) ->
    delete $scope.CartObj.Items[key]

  $scope.loadServerCart = ->
    ServerCartService.initCart($routeParams.storeKey).then(
      (cart) ->
        $scope.ServerCart = cart
      (err) ->
        $scope.error.log err
    )
  $scope.processPayment = ->
    resultAction = (result) ->
      $window.location.href = result.StartPaymentURL

    storeService.getStore($routeParams.storeKey).then(
      (store) ->
        $scope.StoreObj = store
        ServerCartService.process(store.Key, store.PaymentProviders[0]?.ProviderType).then(
          resultAction
          (err) -> $scope.error.log err
        )
      (err) ->
        $scope.error.log err
    )
  $scope.cancelOrder = ->
    ServerCartService.clearCart($routeParams.storeKey).then(
      (success) ->
        if success
          $scope.ServerCart = null
          $scope.cart.clear($routeParams.storeKey)
          flash("Your order has been cancelled")
          $location.path("/")
      (err) ->
        $scope.error.log err
    )


cartCtrl.$inject = ["$scope", "$routeParams", "$location", "$window", "flash", "ServerCartService", "storeService", "UrlSaverService"]