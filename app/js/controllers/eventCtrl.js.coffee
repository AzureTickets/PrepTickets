eventCtrl = @prepTickets.controller("eventCtrl", ($scope, $filter, $location, $routeParams, storeService) ->
  $scope.EventObj = null
  $scope.loadEvent = ->
    unless $scope.StoreObj
      storeService.getStoreByURI($routeParams.storeURI).then(
        (store) ->
          $scope.StoreObj = store
          $scope.EventObj = $filter('findByEventURI')(store.Events, $routeParams.eventURI)
        (err) ->
          $scope.error.log err
      )
  $scope.goBackToStore = ->
    $location.path("school/#{$scope.StoreObj.URI}")
)

eventCtrl.$inject = ["$scope", "$filter", "$location", "$routeParams", "storeService"]