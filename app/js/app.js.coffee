@prepTickets = angular.module('prepTickets', ['ngCookies']).config ["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/stores/index.html'
      controller: 'storeCtrl'
    .otherwise
      redirectTo: '/'
  ]