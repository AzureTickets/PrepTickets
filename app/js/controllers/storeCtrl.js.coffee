storeCtrl = @prepTickets.controller("storeCtrl", ($scope, $location, $routeParams) ->  
  $scope.greeting = 'Hola!'
  $scope.Searching = false
  $scope.Stores = []
  $scope.$on 'initStore', 
    (ev, key) ->
      unless key?
        delete $scope.StoreObj
      else
        $scope.storeKey = key
        $scope.initStore(key)
      
      ev?.stopPropagation?()
  

  $scope.search = (q)->
    $scope.Searching = true
    $scope.Stores = []
    $scope.store.searchStores($scope.query).then(
      (stores) ->
        $scope.Stores = stores
        $scope.Searching = false
      (err) ->
        $scope.error.log err
    )

  $scope.goToStore = (obj) ->
    $scope.store.cacheTheKey(obj.key)
    $location.path("school#{obj.URI}")

  $scope.loadStore = ->
    if (storeKey = $scope.store.getCachedKey())?
      $scope.$emit('initStore', storeKey)
    else
      $scope.store.getStoreKeyByURI("#{$routeParams.storeURI}").then(
        (storeKey) ->
          $scope.store.cacheTheKey(storeKey)
          $scope.$emit('initStore', storeKey)
        (err) ->
          $scope.error.log(err)
      )

  $scope.initStore = (storeKey) ->
    $scope.store.getStore(storeKey).then(
      (store) ->
        $scope.StoreObj = store    
      (err) ->
        $scope.error.log err
    )
)

storeCtrl.$inject = ["$scope", "$location", "$routeParams"]