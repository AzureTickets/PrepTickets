#bug fix for moment.js
window.moment = ender.moment

#Route filters
routeFilters =
  rememberUrl : ['$location', 'UrlSaverService', ($location, UrlSaverService) ->
    unless $location.$$path is '/login' or $location.$$path is '/signup'
      UrlSaverService.save($location.path())
    true
  ]
  requireLogin : ['$q', '$rootScope', '$location', 'ProfileService', 'UrlSaverService', ($q, $rootScope, $location, ProfileService, UrlSaverService) ->
    def = $q.defer()

    ProfileService.get().then(
      (profile) ->
        $rootScope.DomainProfile = profile
        unless ProfileService.isLoggedIn()
          redirect = false
          currentPath = $location.path()

          for pathReg in [/^\/orders/g,                   # any /orders url
                          /^\/profile/g,                  # any /profile url
                          /^\/cart\/[\w\-\d]+\/(.+)/g]    # any /cart/uuid/(something) url. This will allow you to just view original cart, nothing else
            redirect = true if pathReg.test(currentPath)

          if redirect
            $rootScope.flash('error', BWL.t("Login.Required"))
            $location.path('/login')
          else
            def.resolve(true)

        else
          def.resolve(true)

      (err) ->
        def.reject(err)
    )

    def.promise    
  ]

@prepTickets = angular.module('prepTickets', 
  ['ngCookies', 
  'ui.bootstrap.tpls',
  'ui.bootstrap',
  'ngSanitize'])
.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/',
      title: 'Schools'
      templateUrl: 'views/stores/index.html'
      controller: 'storeCtrl'
      resolve: routeFilters
    .when '/school/:storeURI',
      title: 'Loading School...'
      templateUrl: 'views/stores/show.html'
      controller: 'storeCtrl'
      resolve: routeFilters
    .when '/school/:storeURI/event/:eventURI',
      title: 'Loading Event...'
      templateUrl: 'views/events/show.html'
      controller: 'eventCtrl'
      resolve: routeFilters
    .when '/cart/:storeKey',
      title: 'Cart'
      templateUrl: 'views/cart/index.html'
      controller: 'cartCtrl'
      resolve: routeFilters
    .when '/cart/:storeKey/confirm',
      title: 'Cart Confirmation'
      templateUrl: 'views/cart/confirm.html'
      controller: 'cartCtrl'
      resolve: routeFilters
    .when '/cart/:storeKey/instantCheckout',
      title: 'Checkout'
      templateUrl: 'views/cart/instantCheckout.html'
      controller: 'cartCtrl'
      resolve: routeFilters
    .when '/cart/:storeKey/processed',
      title: 'Processed Order'
      templateUrl: 'views/cart/processed.html'
      controller: 'cartProcessedCtrl'
      resolve: routeFilters
    .when '/orders',
      title: 'Orders'
      templateUrl: 'views/orders/index.html'
      controller: 'orderCtrl'
      resolve: routeFilters
    .when '/orders/:storeKey/:orderKey',
      title: 'Loading Order...'
      templateUrl: 'views/orders/show.html'
      controller: 'orderCtrl'
      resolve: routeFilters
    .when '/orders/:storeKey/:orderKey/:ticketKey',
      title: 'Loading Ticket...'
      templateUrl: 'views/tickets/show.html'
      controller: 'orderCtrl'
      resolve: routeFilters
    .when '/login',
      title: 'Login'
      templateUrl: 'views/auth/login.html'
      controller: 'authCtrl'
      resolve: routeFilters
    .when '/signup',
      title: 'Sign up'
      templateUrl: 'views/auth/signup.html'
      controller: 'authCtrl'
      resolve: routeFilters
    .when '/forgot-password',
      title: "Forgot Password"
      templateUrl: 'views/auth/forgotPassword.html'
      controller: 'authCtrl'
      resolve: routeFilters
    .when '/profile',
      title: 'Your Profile'
      templateUrl: 'views/profile/show.html'
      controller: 'profileCtrl'
      resolve: routeFilters
    .when '/profile/edit',
      title: 'Edit Your Profile'
      templateUrl: 'views/profile/edit.html'
      controller: 'profileCtrl'
      resolve: routeFilters
    .when '/profile/change-password',
      title: 'Change Your Profile Password'
      templateUrl: 'views/profile/password.html'
      controller: 'profileCtrl'
      resolve: routeFilters
    .when '/page/:target',
      title: ''
      templateUrl: 'views/pages/show.html'
      controller: 'pageCtrl'
      resolve: routeFilters
    .otherwise
      redirectTo: '/'
])
.run(['$location', '$rootScope', ($location, $rootScope) ->
    $rootScope.$on('$routeChangeSuccess', (event, current, previous) ->
      $rootScope.title = current.$$route?.title;
      $rootScope.selectedCtrl = current.$$route?.controller
    )
])