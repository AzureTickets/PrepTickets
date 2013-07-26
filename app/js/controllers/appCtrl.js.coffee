appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, configService, errorService, flash, authService, storeService, CartService, $location) ->
  $rootScope.errors = []
  
  $rootScope.auth = authService
  $rootScope.cookie = $cookieStore
  $rootScope.config = configService
  $rootScope.error = errorService
  $rootScope.cart = CartService
  $rootScope.store = storeService
  $rootScope.AccountProfile = $rootScope.auth.getAccountProfile()

  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    console.warn rejection if console?
    if typeof rejection is 'object'
      rejection = "Page you were looking for is not found" if rejection.status? && rejection.status == 404
      rejection = rejection.message if rejection.message?
      rejection = rejection.Message if rejection.Message?
    errorService.log "Route Change Error: #{rejection}"

  $rootScope.getProfile = ->
    $rootScope.auth.loadProfile().then(
      (profile) -> 
        $rootScope.DomainProfile = profile
        $rootScope.auth.setDomainProfile(profile)
      (err) ->
        errorService.log(err)
    )

  $rootScope.signout = ->
    $rootScope.auth.signoff().then(
      () ->
        flash 'Successfully signed out'
        $rootScope.getProfile()
        $location.path("/")
    )
  $rootScope.signin = (provider) ->
    if provider?
      # login by provider
      $rootScope.auth.signinByProvider(provider).then(
        (result) ->
          $rootScope.getProfile()
        (err) ->
          $rootScope.loginErr = err
      )
    else
      # login by account
      $rootScope.auth.signin(
        Email : $rootScope.AccountProfile.Email,
        PasswordHash : BWL.Plugins.MD5($rootScope.AccountProfile.Password)
      ).then(
        (result) ->
          flash 'Successfully signed in'
          $location.path("/")
          $rootScope.getProfile()
          # $rootScope.auth.authenticate($rootScope)
        (err) ->
          flash 'danger', err
      )
)

appCtrl.$inject = ["$rootScope", "$cookieStore", "configService", "errorService", "flash", "authService", "storeService", "CartService", "$location"]