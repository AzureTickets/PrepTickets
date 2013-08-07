#bug fix for moment.js
window.moment = ender.moment

@prepTickets = angular.module('prepTickets', 
  ['ngCookies', 
  'ui.bootstrap.tpls',
  'ui.bootstrap'])
.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/',
      title: 'Schools'
      templateUrl: 'views/stores/index.html'
      controller: 'storeCtrl'
    .when '/school/:storeURI',
      title: 'Loading School...'
      templateUrl: 'views/stores/show.html'
      controller: 'storeCtrl'
    .when '/school/:storeURI/event/:eventURI',
      title: 'Loading Event...'
      templateUrl: 'views/events/show.html'
      controller: 'eventCtrl'
    .when '/cart/:storeKey',
      title: 'Cart'
      templateUrl: 'views/cart/index.html'
      controller: 'cartCtrl'
    .when '/cart/:storeKey/confirm',
      title: 'Cart Confirmation'
      templateUrl: 'views/cart/confirm.html'
      controller: 'cartCtrl'
    .when '/cart/:storeKey/instantCheckout',
      title: 'Checkout'
      templateUrl: 'views/cart/instantCheckout.html'
      controller: 'cartCtrl'
    .when '/cart/:storeKey/processed',
      title: 'Processed Order'
      templateUrl: 'views/cart/processed.html'
      controller: 'cartProcessedCtrl'
    .when '/orders',
      title: 'Orders'
      templateUrl: 'views/orders/index.html'
      controller: 'orderCtrl'
    .when '/orders/:storeKey/:orderKey',
      title: 'Loading Order...'
      templateUrl: 'views/orders/show.html'
      controller: 'orderCtrl'
    .when '/orders/:storeKey/:orderKey/:ticketKey',
      title: 'Loading Ticket...'
      templateUrl: 'views/tickets/show.html'
      controller: 'orderCtrl'
    .when '/signin',
      title: 'Sign in'
      templateUrl: 'views/auth/signin.html'
      controller: 'authCtrl'
    .when '/profile',
      title: 'Your Profile'
      templateUrl: 'views/profile/show.html'
      controller: 'profileCtrl'
    .when '/profile/edit',
      title: 'Edit Your Profile'
      templateUrl: 'views/profile/edit.html'
      controller: 'profileCtrl'
    .when '/profile/change-password',
      title: 'Change Your Profile Password'
      templateUrl: 'views/profile/password.html'
      controller: 'profileCtrl'
    .otherwise
      redirectTo: '/'
])
.run(['$location', '$rootScope', ($location, $rootScope) ->
    $rootScope.$on('$routeChangeSuccess', (event, current, previous) ->
      $rootScope.title = current.$$route?.title;
      $rootScope.selectedCtrl = current.$$route?.controller
    )
])