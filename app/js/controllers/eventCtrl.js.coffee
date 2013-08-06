eventCtrl = @prepTickets.controller("eventCtrl", ($scope, $filter, $location, $routeParams, storeService) ->
  $scope.EventObj = null
  $scope.loadEvent = ->
    unless $scope.StoreObj
      storeService.getStoreByURI($routeParams.storeURI).then(
        (store) ->
          $scope.StoreObj = store
          $scope.setupEventObj()
        (err) ->
          $scope.error.log err
      )
    else
      $scope.setupEventObj()
      

  $scope.setupEventObj = (eventUri=$routeParams.eventURI) ->
    $scope.EventObj = $filter('findByEventURI')($scope.StoreObj.Events, eventUri)
    $scope.root.title = "#{$scope.EventObj.Name} @ #{$scope.StoreObj.Name}"
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

    $scope.CurrentCart
    
  $scope.saveCart = ->
    if $scope.eventForm.$valid
      $scope.cart.addCart($scope.CurrentCart)
      $location.path("cart/#{$scope.StoreObj.Key}")
    
  $scope.quantityFor = (obj) ->
    $scope.cart.quantityFor(obj.StoreKey, obj.Key, obj.Type)
)

eventCtrl.$inject = ["$scope", "$filter", "$location", "$routeParams", "storeService"]