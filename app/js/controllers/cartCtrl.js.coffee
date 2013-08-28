#Cart Controller
cartCtrl = @prepTickets.controller "cartCtrl", ($scope, $routeParams, $location, $window, ServerCartService, UrlSaverService) ->
  $scope.processingRequest = false
  $scope.hastAgreed = false
  $scope.iAgree = false
  $scope.PurchaseButtonText = BWL.t("Cart.Button.CompletePurchase", defaultValue:"Complete Purchase")

  #Watches for the server to be uploaded and redirects when it fires.
  $scope.$on "ServerCart:Uploaded", ->
    UrlSaverService.clear() 
    $location.path("cart/#{$routeParams.storeKey}/confirm")

  #Setups up cart for the given store
  $scope.setupCart = (storeKey=$routeParams.storeKey) ->
    $scope.store.getStore(storeKey).then(
      (store) ->
        $scope.StoreObj = store
        $scope.CartObj = $scope.cart.getCartObj(storeKey)
        $scope.breadcrumbs.addCart(store)
      (err) ->
        $scope.error.log err
    )
  
  #clears given cart and redirects back to root url
  $scope.clearCart = (storeKey=$routeParams.storeKey) ->
    if $scope.cart.clear(storeKey)
      $scope.flash('Cart has been cleared')
      $scope.CartObj = null
    $location.path("/")

  #saves and uploads current cart to server.
  $scope.checkout = ->
    return if $scope.processingRequest
    $scope.processingRequest = true
    $scope.cart.replaceCart($scope.CartObj)
    if $scope.auth.isSignedIn()
      $scope.cart.sendToServer().then( #once completed, it will fire ServerCart:Uploaded event
        (result) ->
          #do nothing
        (err) ->
          if err is BWL.t("DataAccess.Error", msg:"Cart is currently is a Done state.")
            #TODO: LOG THIS TO THE SERVER, THIS ERROR SHOULD NEVER HAPPEN
            console.warn "Oh no: #{err}" if console?
            ServerCartService.clearCart($routeParams.storeKey).then(
              (success) ->
                $scope.processingRequest = false
                $scope.checkout()
              (errAgain) ->
                $scope.processingRequest = false
                $scope.error.log errAgain
            )
          else
            $scope.processingRequest = false
            $scope.error.log err
      )
    else
      $scope.flash(BWL.t("Signin.Required", defaultValue: "You must sign in or sign up before you can continue"))
      UrlSaverService.save("cart/#{$routeParams.storeKey}/instantCheckout")
      $scope.processingRequest = false
      $location.path("signin")

  #Does the same as setupCart and Checkout.
  #Mainly used when a user signs in to checkout
  $scope.instantCheckout = ->
    $scope.setupCart()
    $scope.cart.sendToServer() #once completed, it will fire ServerCart:Uploaded event

  #Removes an item from cart
  #@param {string} key Key of the item in the cart
  #@returns {object} Item Item which was deleted
  $scope.removeItem = (key) ->
    delete $scope.CartObj.Items[key]

  #Loads the server cart for given storeKey
  #@returns null
  $scope.loadServerCart = (storeKey=$routeParams.storeKey) ->
    $scope.store.getStore(storeKey).then(
      (store) ->
        $scope.StoreObj = store
        $scope.breadcrumbs.addCartCheckout(store)
        ServerCartService.initCart(storeKey).then(
          (cart) ->
            $scope.ServerCart = cart
          (err) ->
            $scope.error.log err
        )
      (err) ->
        $scope.error.log err
    )
    
    null

  #Setups up URL for user to process payment for given storeKey
  $scope.processPayment = (storeKey=$routeParams.storeKey) ->
    return if $scope.processingRequest
    $scope.processingRequest = true
    $scope.PurchaseButtonText = "Processing..."


    resultAction = (result) ->
      $window.location.href = result.StartPaymentURL

    $scope.store.getStore(storeKey).then(
      (store) ->
        $scope.StoreObj = store
        ServerCartService.process(store.Key, store.PaymentProviders[0]?.ProviderType).then(
          resultAction
          (err) => 
            $scope.paymentFailed()
            $scope.error.log err
        )
      (err) ->
        $scope.paymentFailed()
        $scope.error.log err
    )
    null

  $scope.paymentFailed = ->
    $scope.processingRequest = false
    $scope.PurchaseButtonText = BWL.t("Cart.Button.CompletePurchase", defaultValue:"Complete Purchase")

  #Cancels an Order (server side cart) for a given store
  $scope.cancelOrder = (storeKey=$routeParams.storeKey) ->
    ServerCartService.clearCart(storeKey).then(
      (success) ->
        if success
          $scope.ServerCart = null
          $scope.cart.clear(storeKey)
          $scope.CartObj = null
          $scope.flash("Your order has been cancelled")
          $location.path("/")
      (err) ->
        $scope.error.log err
    )
    null

  #Subtotal Calculation
  $scope.subtotal = ->
    total = 0
    if $scope.CartObj?
      for key, item of $scope.CartObj.Items 
        total += item.Price * item.Quantity
    total


cartCtrl.$inject = ["$scope", "$routeParams", "$location", "$window", "ServerCartService", "UrlSaverService"]