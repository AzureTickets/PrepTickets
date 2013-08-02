authCtrl = @prepTickets.controller("authCtrl", ($scope, $location, UrlSaverService) ->
  $scope.authProviders = []
  $scope.passwordLength = BWL.t("Signup.Password.Length", defaultValue:"6")

  $scope.loadAuthProviders = ->
    omitAccounts = (providers) ->
      accountsIdx = providers.indexOf("Accounts")        
      providers.slice(0, accountsIdx).concat(providers.slice(accountsIdx + 1, providers.length)) if accountsIdx > -1

    $scope.auth.loadAuthProviders().then(
      (providers) -> 
        $scope.authProviders = omitAccounts(providers)
      (err) -> $scope.error.log(err);
    )

  $scope.signup = ->
    if $scope.signupForm.$valid
      $scope.auth.register($scope.NewAccount).then(
        (success) ->
          $scope.flash(BWL.t("Signup.Complete", defaultValue:"Signup Complete, please check your email to verify your account"))
          $location.path(UrlSaverService.loadLocal())
        (err) ->
          $scope.flash("error", err).now()
      )
)

authCtrl.$inject = ['$scope', "$location", "UrlSaverService"]