appCtrl = @prepTickets.controller('appCtrl', ($rootScope, $cookieStore, configService, errorService, flash, authService) ->
  $rootScope.errors = []
  $rootScope.auth = authService
  $rootScope.cookie = $cookieStore
  $rootScope.config = configService

  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    console.warn rejection if console?
    errorService.log "Route Change Error: #{rejection}"

  $rootScope.getProfile = ->
    $rootScope.auth.loadProfile().then(
      (profile) -> 
        console.log profile
      (err) ->
        errorService.log(err)
    )

  $rootScope.signin = (provider) ->
    if provider?
      # login by provider
      $rootScope.auth.signinByProvider(provider).then(
        (result) ->
          console.log result
          $rootScope.DomainProfile = $rootScope.auth.getDomainProfile();
          $cookieStore.put($rootScope.config.cookies.loggedStatus, true);

          # $rootScope.init();
        (err) ->
          $rootScope.loginErr = err;
        )
    else
      # login by account
      $rootScope.auth.logonAsync(
        Email : $rootScope.AccountProfile.Email,
        PasswordHash : BWL.Plugins.MD5($rootScope.AccountProfile.Password)
      ).then(
        () ->
          $rootScope.auth.authenticate($rootScope)
        (err) ->
          $rootScope.loginErr = err
      )
)

appCtrl.$inject = ["$rootScope", "$cookieStore", "configService", "errorService", "flash", "authService"]