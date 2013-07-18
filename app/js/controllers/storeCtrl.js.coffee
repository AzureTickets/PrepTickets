@prepTickets.controller("storeCtrl", [
  "$scope", 
  "$cookieStore", 
  "$location", 
  "$timeout", 
  "$routeParams", 
  "storeService",
  ($scope, $cookieStore, $location, $timeout, $routeParams, storeService) ->  
    $scope.greeting = 'Hola!'
    $scope.stores = []
    $scope.search = (q)->
      storeService.searchStores($scope.query).then(
        (stores) ->
          console.log "Stores are: ", stores
          $scope.stores = stores
        (err) ->
          console.log err
      )
    $scope.init = ->
      $scope.auth.authenticate($scope).then(
        ->
          $scope.DomainProfile = $scope.auth.getDomainProfile();

          # // redirect to login if no profile, but allow store visitors
          unless $routeParams.storeURI? || $scope.DomainProfile.Key?
            $location.path('/auth/login')
            return
          

          # // if we are accessing a store from URI
          if $routeParams.storeURI?
            $scope.store.getStoreKeyByURI($routeParams.storeURI).then(
              (storeKey) ->
                $scope.storeURI = $routeParams.storeURI;
                $scope.$emit('initStore', storeKey);
              (err) ->
                $scope.error.log(err)
            )
          else if $scope.auth.hasStoreAccess()
            # // check if user has access to a store and populate list if so
            $scope.store.listStores(1).then(
              ->
                $scope.stores = $scope.store.getStores()

                if !angular.isArray($scope.stores)
                  # // if user has been upgraded but have not yet created a
                  # // store
                  $scope.createStore();
                else
                  storeKey = $cookieStore.get($scope.config.cookies.storeKey) || $scope.stores[0].Key
                  $scope.$emit('initStore', storeKey);
              (err) ->
                $scope.error.log(err)
            )
          else if $scope.auth.isLogged()
            $scope.createStore()          
        (err) ->
          $scope.error.log(err)
      )
])
