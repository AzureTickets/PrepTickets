@prepTickets = angular.module('prepTickets', 
  ['ngCookies', 
  'ui.bootstrap'])
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
    .when '/cart/:storeKey/confirm',
      templateUrl: 'views/cart/confirm.html'
      controller: 'cartCtrl'
    .when '/cart/:storeKey/instantCheckout',
      templateUrl: 'views/cart/instantCheckout.html'
      controller: 'cartCtrl'
    .when '/cart/:storeKey/processed',
      templateUrl: 'views/cart/processed.html'
      controller: 'cartProcessedCtrl'
    .when '/orders',
      templateUrl: 'views/orders/index.html'
      controller: 'orderCtrl'
    .when '/orders/:storeKey/:orderKey',
      templateUrl: 'views/orders/show.html'
      controller: 'orderCtrl'
    .when '/orders/:storeKey/:orderKey/:ticketKey',
      templateUrl: 'views/orders/ticket.html'
      controller: 'orderCtrl'
    .when '/signin',
      templateUrl: 'views/auth/signin.html'
      controller: 'authCtrl'
    .otherwise
      redirectTo: '/'
])