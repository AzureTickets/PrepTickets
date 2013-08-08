appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, $window, configService, errorService, flash, authService, storeService, CartService, $location, UrlSaverService, ModalService, ProfileService) ->
  $rootScope.errors = []
  $rootScope.navCollapsed = true
  $rootScope.title = ""
  
  $rootScope.auth = authService
  $rootScope.cookie = $cookieStore
  $rootScope.config = configService
  $rootScope.error = errorService
  $rootScope.cart = CartService
  $rootScope.store = storeService
  $rootScope.modal = ModalService
  $rootScope.flash = flash
  $rootScope.profile = ProfileService
  $rootScope.root = $rootScope

  $rootScope.AccountProfile = {} #needed for email signin to work

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
      (err) ->
        errorService.log(err)
    )

  $rootScope.signout = ->
    $rootScope.auth.signoff().then(
      (result) ->
        $rootScope.profile.clear()
        $rootScope.DomainProfile = {}
        flash('Successfully signed out')
        $location.path("/")
      (err) ->
        $rootScope.error.log err
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
              $rootScope.AccountProfile = {}
              if UrlSaverService.localUrl()
                $location.path(UrlSaverService.loadLocal())
              else
                flash.now()
                #TODO: might want to add a timeout for redirect so user sees flash.now()
                $window.location.href = UrlSaverService.load()
            (err) ->
              flash('error', err).now()
          )
        (err) ->
          flash('error', err).now()
      )
)

appCtrl.$inject = ["$rootScope",
                   "$cookieStore",
                   "$window",
                   "configService",
                   "errorService",
                   "flash",
                   "authService",
                   "storeService",
                   "CartService",
                   "$location",
                   "UrlSaverService",
                   "ModalService",
                   "ProfileService"]