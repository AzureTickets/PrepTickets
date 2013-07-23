appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, configService, errorService, flash, authService, storeService) ->
  $rootScope.errors = []
  $rootScope.StoreObj = storeService.getBlankStore()
  
  $rootScope.auth = authService
  $rootScope.cookie = $cookieStore
  $rootScope.config = configService
  $rootScope.error = errorService
  $rootScope.DomainProfile = $rootScope.auth.getDomainProfile()
  $rootScope.AccountProfile = $rootScope.auth.getAccountProfile()

  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    console.warn rejection if console?
    errorService.log "Route Change Error: #{rejection}"

  $rootScope.getProfile = ->
    $rootScope.auth.loadProfile().then(
      (profile) -> 
        console.log "Login profile: ", profile
        $rootScope.DomainProfile = profile
        $rootScope.auth.setDomainProfile(profile)
      (err) ->
        errorService.log(err)
    )

  $rootScope.signin = (provider) ->
    if provider?
      # login by provider
      $rootScope.auth.signinByProvider(provider).then(
        (result) ->
          $rootScope.getProfile
          # $rootScope.DomainProfile = $rootScope.auth.getDomainProfile();
          # $cookieStore.put($rootScope.config.cookies.loggedStatus, true);

          # $rootScope.init();
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
          $rootScope.getProfile()
          $rootScope.auth.authenticate($rootScope)
        (err) ->
          flash 'danger', err
      )
)

appCtrl.$inject = ["$rootScope", "$cookieStore", "configService", "errorService", "flash", "authService", "storeService"]