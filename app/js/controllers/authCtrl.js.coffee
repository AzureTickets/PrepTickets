authCtrl = @prepTickets.controller("authCtrl", ($scope, errorService) ->
  $scope.authProviders = []

  $scope.loadAuthProviders = ->
    omitAccounts = (providers) ->
      accountsIdx = providers.indexOf("Accounts")        
      providers.slice(0, accountsIdx).concat(providers.slice(accountsIdx + 1, providers.length)) if accountsIdx > -1

    $scope.auth.loadAuthProviders().then(
      (providers) -> 
        $scope.authProviders = omitAccounts(providers)
      (err) -> errorService.log(err);
    )
)

authCtrl.$inject = ['$scope', 'errorService']