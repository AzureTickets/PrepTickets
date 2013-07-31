eventCtrl = @prepTickets.controller("eventCtrl", ($scope, $filter, $location, $routeParams, storeService) ->
  $scope.EventObj = null
  $scope.loadEvent = ->
    unless $scope.StoreObj
      storeService.getStoreByURI($routeParams.storeURI).then(
        (store) ->
          $scope.StoreObj = store
          $scope.EventObj = $filter('findByEventURI')(store.Events, $routeParams.eventURI)
          $scope.buildCart()
        (err) ->
          $scope.error.log err
      )
    else
      $scope.EventObj = $filter('findByEventURI')($scope.StoreObj.Events, $routeParams.eventURI)
      $scope.buildCart()

  #TODO: This might need to be inside the cart service
  $scope.buildCart = ->
    return $scope.CurrentCart if $scope.CurrentCart?
    $scope.CurrentCart = 
      StoreKey: $scope.StoreObj.Key
      StoreName: $scope.StoreObj.Name
      PaymentType: $scope.StoreObj.PaymentProviders[0]?.ProviderType
      Items: {}

    for item in $scope.EventObj.Items
      $scope.CurrentCart.Items[item.Key] =
        Quantity: 0
        EventKey: $scope.EventObj.Key
        EventName: $scope.EventObj.Name
        Key: item.Key
        Type: item.Type
        Name: item.Name
        Price: item.Price.ItemPrice
        Total: ->
          @Price * @Quantity

    $scope.CurrentCart
    
  $scope.saveCart = ->
    $scope.cart.addCart($scope.CurrentCart)
    $location.path("cart/#{$scope.StoreObj.Key}")
    
  $scope.quantityFor = (obj) ->
    $scope.cart.quantityFor(obj.StoreKey, obj.Key, obj.Type)
)

eventCtrl.$inject = ["$scope", "$filter", "$location", "$routeParams", "storeService"]