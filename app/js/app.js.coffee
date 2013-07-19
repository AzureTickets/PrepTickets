@prepTickets = angular.module('prepTickets', 
  ['ngCookies', 
  "ui.bootstrap"])
.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/stores/index.html'
      controller: 'storeCtrl'
    .when '/school/:storeUrl',
      templateUrl: 'views/stores/show.html'
      controller: 'storeCtrl'
    .when '/signin',
      templateUrl: 'views/auth/signin.html'
      controller: 'authCtrl'
    .otherwise
      redirectTo: '/'
])