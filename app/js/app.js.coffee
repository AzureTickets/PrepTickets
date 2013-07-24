@prepTickets = angular.module('prepTickets', 
  ['ngCookies', 
  "ui.bootstrap"])
.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/stores/index.html'
      controller: 'storeCtrl'
    .when '/school/:storeURI',
      templateUrl: 'views/stores/show.html'
      controller: 'storeCtrl'
    .when '/school/:storeURI/event/:eventURI',
      templateUrl: 'views/events/show.html'
      controller: 'eventCtrl'
    .when '/signin',
      templateUrl: 'views/auth/signin.html'
      controller: 'authCtrl'
    .otherwise
      redirectTo: '/'
])