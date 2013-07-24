@prepTickets.controller("storeCtrl", [
  "$scope", 
  "$location", 
  "$routeParams", 
  "storeService",
  ($scope, $location, $routeParams, storeService) ->  
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

    $scope.goToEvent = (routeObj) ->
      $location.path("school/#{$routeParams.storeURI}/event/#{routeObj.URI}")      

    $scope.loadStore = ->
      if (storeKey = storeService.getCachedKey())?
        $scope.$emit('initStore', storeKey)
      else
        $scope.store.getStoreKeyByURI("#{$routeParams.storeURI}").then(
          (storeKey) ->
            storeService.cacheTheKey(storeKey)
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
      
    
])
