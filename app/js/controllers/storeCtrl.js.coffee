@prepTickets.controller("storeCtrl", [
  "$scope", 
  "$cookieStore", 
  "$location", 
  "$timeout", 
  "$routeParams", 
  "storeService",
  ($scope, $cookieStore, $location, $timeout, $routeParams, storeService) ->  
    $scope.greeting = 'Hola!'
    $scope.store = storeService
    $scope.$on('initStore', 
      (ev, key) ->
        unless key?
          delete $scope.StoreObj
        else
          $scope.storeKey = key
          $scope.initStore(key)
        
        ev?.stopPropagation?()
    )

    $scope.search = (q)->
      storeService.searchStores($scope.query).then(
        (stores) ->
          #Do nothing
        (err) ->
          $scope.error.log err
      )

    $scope.goToStore = (obj) ->
      storeService.cacheTheKey(obj.key)
      $location.path("school#{obj.URI}")

    $scope.loadStore = ->
      if (storeKey = storeService.getCachedKey())?
        $scope.$emit('initStore', storeKey)
      else
        $scope.store.getStoreKeyByURI("#{$routeParams.storeURI}").then(
          (storeKey) ->
            $scope.storeURI = $routeParams.storeURI
            storeService.cacheTheKey(storeKey)
            $scope.$emit('initStore', storeKey)
          (err) ->
            $scope.error.log(err)
        )

    $scope.initStore = (storeKey) ->
      if storeKey?
        $scope.store.initStore(storeKey).then(
          (store, currency) ->
            if storeService.isSameAsCachedKey(store.Key)
              console.log store, currency
              $scope.StoreObj = store
            else
              storeService.clearTheKey()
              $scope.loadStore()
          (err) ->
            $scope.error.log(err)
        )
    
])
