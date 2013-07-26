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
    .when '/cart/:storeKey',
      templateUrl: 'views/cart/index.html'
      controller: 'cartCtrl'
    .when '/signin',
      templateUrl: 'views/auth/signin.html'
      controller: 'authCtrl'
    .otherwise
      redirectTo: '/'
])