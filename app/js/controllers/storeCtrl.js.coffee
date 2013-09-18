storeCtrl = @prepTickets.controller("storeCtrl", ($scope, $location, $routeParams, $filter, $q, SmoothScroll) ->  
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
    def = $q.defer()

    if(query?.length >= 3)
      $scope.query = query
      $scope.Searching = true
      $scope.FoundNothing = false
      $scope.store.searchStores(query).then(
        (stores) ->
          $scope.Stores = stores
          $scope.GroupedStores = $filter("groupBy")(stores, 3, {blank: true})
          $scope.FoundNothing = true if stores.length == 0
          $scope.Searching = false
          if autoscroll
            SmoothScroll.scrollTo("results", 100)
          def.resolve(stores)
        (err) ->
          $scope.error.log err
          def.reject err
      )
    else
      $scope.Stores = []

    def.promise

  $scope.typeaheadSelect = ->
    $scope.goToStore $scope.selectedSchool

  $scope.goToStore = (obj) ->
    $scope.store.cacheTheKey(obj.key)
    $location.path("school#{obj.URI}")

  $scope.loadStore = ->
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
        $scope.breadcrumbs.addStore(store)
      (err) ->
        $scope.error.log err
    )
)

storeCtrl.$inject = ["$scope", "$location", "$routeParams", "$filter", "$q", "SmoothScroll"]