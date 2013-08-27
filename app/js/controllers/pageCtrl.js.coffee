pageCtrl = @prepTickets.controller('pageCtrl', ($scope, $rootScope, $location, $routeParams) ->
  camelCase = (input) ->
    input.toLowerCase().replace(/-(.)/g, (match, group1) ->
        return group1.toUpperCase()
    )

  $scope.initPage = ->
    page = BWL.t("Page.#{camelCase($routeParams.target)}", defaultValue: "null")
    if page is "null"
      $scope.flash('error', BWL.t("Page.NotFound", defaultValue:"404: Unable to find the page you requested"))
      $location.path("/")
    else
      $rootScope.title =  BWL.t("Page.#{camelCase($routeParams.target)}.Title", defaultValue: "Unknown")
      $scope.content =  BWL.t("Page.#{camelCase($routeParams.target)}.Content", defaultValue: "")
)
pageCtrl.$inject = ["$scope", "$rootScope", "$location", "$routeParams"]