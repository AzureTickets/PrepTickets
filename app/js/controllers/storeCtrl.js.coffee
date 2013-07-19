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
    $scope.$on('initStore', (ev, key) ->
        unless key?
          delete $scope.StoreObj;
        else
          $scope.storeKey = key;
          $cookieStore.put($scope.config.cookies.storeKey, key);
          $scope.initStore(key);
        
        if (ev? && angular.isFunction(ev.stopPropagation))
          ev.stopPropagation()
        
    )

    $scope.search = (q)->
      storeService.searchStores($scope.query).then(
        (stores) ->
          #Do nothing
        (err) ->
          console.log err
      )

    $scope.goToStore = (obj) ->
      $location.path("school#{obj.URI}")

    $scope.loadStore = ->
      console.log $routeParams
      $scope.store.getStoreKeyByURI($routeParams.storeURI).then(
        (storeKey) ->
          $scope.storeURI = $routeParams.storeURI
          $scope.$emit('initStore', storeKey)
        (err) ->
          $scope.error.log(err)
      )

    $scope.initStore = (storeKey) ->
      if storeKey?
        $scope.store.initStore(storeKey).then(
          (store, currency) ->
            console.log store, currency
            $scope.Store = store
        )

    $scope.init = ->
      $scope.auth.authenticate($scope).then(
        ->
          $scope.DomainProfile = $scope.auth.getDomainProfile();

          # // if we are accessing a store from URI
          if $routeParams.storeURI?
            $scope.store.getStoreKeyByURI($routeParams.storeURI).then(
              (storeKey) ->
                $scope.storeURI = $routeParams.storeURI;
                $scope.$emit('initStore', storeKey);
              (err) ->
                $scope.error.log(err)
            )
        (err) ->
          $scope.error.log(err)
      )
])
