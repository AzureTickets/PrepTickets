storeCtrl = @prepTickets.controller("storeCtrl", ($scope, $location, $routeParams, SmoothScroll) ->  
  $scope.greeting = 'Hola!'
  $scope.Searching = false
  $scope.$on 'initStore', 
    (ev, key) ->
      unless key?
        delete $scope.StoreObj
      else
        $scope.storeKey = key
        $scope.initStore(key)
      
      ev?.stopPropagation?()
  

  $scope.search = (query=$scope.query, autoscroll=true)->
    if(query?.length >= 3)
      $scope.Searching = true
      $scope.FoundNothing = false
      $scope.store.searchStores(query).then(
        (stores) ->
          $scope.Stores = stores
          $scope.FoundNothing = true if stores.length == 0
          $scope.Searching = false
          if autoscroll
            SmoothScroll.scrollTo("results", 100)
        (err) ->
          $scope.error.log err
      )
    else
      $scope.Stores = []


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
        $scope.root.title = store.Name
        $scope.StoreObj = store    
      (err) ->
        $scope.error.log err
    )
)

storeCtrl.$inject = ["$scope", "$location", "$routeParams", "SmoothScroll"]