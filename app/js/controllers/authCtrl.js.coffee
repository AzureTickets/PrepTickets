authCtrl = @prepTickets.controller("authCtrl", ($scope, $location, UrlSaverService) ->
  $scope.authProviders = []
  $scope.signupComplete = false
  $scope.errorMessage = false
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
    $scope.signupComplete = false
    $scope.errorMessage = false
    if $scope.signupForm.$valid
      $scope.auth.register($scope.NewAccount).then(
        (success) ->
          $scope.signupComplete = true
          $scope.NewAccount = {}
          $scope.clearForm($scope.signupForm)
        (err) ->
          $scope.errorMessage = err
      )
  $scope.forgotPasswordBreadcrumb = ->
    $scope.breadcrumbs.addForgotPassword();
  $scope.forgotPassword = ->
    if $scope.forgotPasswordForm.$valid
      $scope.auth.forgotPassword($scope.AccountProfile).then(
        (success) ->
          $scope.flash(BWL.t("ForgotPassword.Message.Completed", defaultValue:"Please check your email for the reset password link"))
          $location.path("/login")
        (err) ->
          $scope.flash("danger", err).now()
      )
  $scope.clearForm = (form) ->
    elements = angular.element($(".ng-dirty")).val("")
    form.$dirty = false
    form.$pristine = true
    for name, field of form
      field.$pristine = true
      field.$dirty = false
    elements.removeClass("ng-dirty").removeClass("ng-invalid").removeClass("ng-invalid-required").addClass("ng-pristine")
)

authCtrl.$inject = ['$scope', "$location", "UrlSaverService"]