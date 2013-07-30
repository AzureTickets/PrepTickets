appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, $window, configService, errorService, flash, authService, storeService, CartService, $location, UrlSaverService) ->
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
        flash('Successfully signed out').now()
        $rootScope.getProfile()
    )
  $rootScope.signin = (provider) ->
    if provider?
      # login by provider
      $rootScope.auth.signinByProvider(provider, UrlSaverService.load()).then(
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
          $rootScope.getProfile().then(
            (profile) ->
              flash('Successfully signed in')
              if UrlSaverService.localUrl()
                $location.path(UrlSaverService.loadLocal())
              else
                flash.now()
                #TODO: might want to add a timeout for redirect so user sees flashMsg
                $window.location.href = UrlSaverService.load()
            (err) ->
              flash('danger', err).now()
          )
        (err) ->
          flash('danger', err).now()
      )
)

appCtrl.$inject = ["$rootScope", "$cookieStore", "$window", "configService", "errorService", "flash", "authService", "storeService", "CartService", "$location", "UrlSaverService"]