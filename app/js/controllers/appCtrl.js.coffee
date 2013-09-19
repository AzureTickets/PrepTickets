appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, $window, configService, errorService, flash, authService, storeService, CartService, $location, UrlSaverService, ModalService, ProfileService, BreadcrumbService) ->
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
  $rootScope.breadcrumbs = BreadcrumbService
  $rootScope.root = $rootScope

  $rootScope.AccountProfile = {} #needed for email login to work

  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    console.warn rejection if console?
    if typeof rejection is 'object'
      rejection = "Page you were looking for is not found" if rejection.status? && rejection.status == 404
      rejection = rejection.message if rejection.message?
      rejection = rejection.Message if rejection.Message?
    errorService.log "#{rejection}"

  $rootScope.clearBreadcrumbs =  ->
    $rootScope.breadcrumbs.clear()

  $rootScope.getProfile = ->
    $rootScope.auth.loadProfile().then(
      (profile) -> 
        $rootScope.DomainProfile = profile
      (err) ->
        errorService.log(err)
    )

  $rootScope.logout = ->
    $rootScope.auth.signoff().then(
      (result) ->
        $rootScope.profile.clear()
        $rootScope.DomainProfile = {}
        flash(BWL.t("System.Message.Logout", defaultValue: 'Successfully logged out')).now()
        $location.path("/")
      (err) ->
        $rootScope.error.log err
    )
  $rootScope.login = (provider) ->
    if provider?
      # login by provider
      $rootScope.auth.loginByProvider(provider, UrlSaverService.load()).then(
        (result) ->
          $rootScope.getProfile()
        (err) ->
          $rootScope.loginErr = err
      )
    else
      # login by account
      $rootScope.auth.login(
        Email : $rootScope.AccountProfile.Email,
        PasswordHash : BWL.Plugins.MD5($rootScope.AccountProfile.Password)
      ).then(
        (result) ->
          $rootScope.getProfile().then(
            (profile) ->
              flash('Successfully signed in') if $rootScope.auth.isLoggedIn()
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
                   "ProfileService",
                   "BreadcrumbService"]