authCtrl = @prepTickets.controller("authCtrl", ($scope, errorService) ->
  $scope.authProviders = []

  $scope.loadAuthProviders = ->
    $scope.auth.loadAuthProviders().then(
      (providers) -> $scope.authProviders = providers
      (err) -> errorService.log(err);
    )
)

authCtrl.$inject = ['$scope', 'errorService']