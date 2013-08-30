authCtrl = @prepTickets.controller("authCtrl", ($scope, $location, UrlSaverService) ->
  $scope.authProviders = []
  $scope.passwordLength = BWL.t("Signup.Password.Length", defaultValue:"6")
  $scope.breadcrumbs.addLogin()

  $scope.loadAuthProviders = ->
    omitAccounts = (providers) ->
      accountsIdx = providers.indexOf("Accounts")        
      providers.slice(0, accountsIdx).concat(providers.slice(accountsIdx + 1, providers.length)) if accountsIdx > -1

    $scope.auth.loadAuthProviders().then(
      (providers) -> 
        $scope.authProviders = omitAccounts(providers)
      (err) -> $scope.error.log(err);
    )
  $scope.iconFor = (provider) ->
    icon = switch provider.toString().toLowerCase()
      when "facebook", "twitter", "linkedin" then provider.toString().toLowerCase()
      when "google" then "google-plus"
      else "user"

    "icon-#{icon}"
  $scope.providerImgUrl = (provider) ->
    "/img/social/#{provider.toString().toLowerCase()}.png"

  $scope.signup = ->
    if $scope.signupForm.$valid
      $scope.auth.register($scope.NewAccount).then(
        (success) ->
          $scope.flash(BWL.t("Signup.Message.Complete", defaultValue:"Signup Complete, please check your email to verify your account"))
          $location.path(UrlSaverService.loadLocal())
        (err) ->
          $scope.flash("danger", err).now()
      )
  $scope.forgotPasswordBreadcrumb = ->
    $scope.breadcrumbs.addForgotPassword();
  $scope.forgotPassword = ->
    if $scope.forgotPasswordForm.$valid
      $scope.auth.forgotPassword($scope.AccountProfile).then(
        (success) ->
          console.log success
          $scope.flash(BWL.t("ForgotPassword.Message.Completed", defaultValue:"Please check your email for the reset password link"))
          $location.path("/login")
        (err) ->
          $scope.flash("danger", err).now()
      )
)

authCtrl.$inject = ['$scope', "$location", "UrlSaverService"]