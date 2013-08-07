profileCtrl = @prepTickets.controller "profileCtrl", ($scope, $location, ProfileService) ->
  $scope.Contact = {}
  $scope.loadProfile = ->
    $scope.auth.loadProfile().then(
      (profile) ->
        $scope.root.DomainProfile = profile
        angular.copy(profile.Contact, $scope.Contact)
      (err) ->
        $scope.error.log err
    )
  $scope.saveProfile = ->
    if $scope.profileForm.$valid
      $scope.flash.clear()
      ProfileService.saveContact($scope.Contact).then(
        (result) ->
          console.log result
          $scope.flash("Your profile has been updated")
          $scope.auth.loadProfile(true)
          $location.path("/profile")
        (err) ->
          console.log err
          $scope.error.log err
      )
    else
      $scope.flash("error", "Unable to save, please check the form for any errors and try again").now()

  $scope.savePassword = ->
    if $scope.passwordForm.$valid
      $scope.flash.clear()
      alert "Feature coming soon..."
      # ProfileService.savePassword($scope.Contact.NewPassword).then(
      #   (success) ->
      #     console.log success
      #     flash("You've successfully changed your password")
      #     $location.path("/profile")
      #   (err) -> $scope.error.log err
      # )
    else
      $scope.flash("error", "Unable to save, please check the form for any errors and try again").now()


profileCtrl.$inject = ["$scope", "$location", "ProfileService"]