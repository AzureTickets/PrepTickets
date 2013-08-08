# authentication service
authService = @prepTickets.factory 'authService', (configService, $q, $rootScope, modelService, $cookieStore, $window, UrlSaverService, ProfileService) ->
    _domainProfile = {}
    
    isSignedIn: ->
      _domainProfile.ProfileRole >= BWL.Models.DomainProfileRoleEnum.Authenticated
    
    loadProfile : (force = false) ->
      ProfileService.get(force).then(
        (profile) ->
          _domainProfile = profile
        (err) -> $rootScope.error.log err
      )
    
    signinByProvider : (provider, returnURL = $window.location.href) ->
      def = $q.defer()

      BWL.Services.Account.GetProfile(
        (profile) ->
          if (profile.DomainProfileId isnt 0)
            $rootScope.$apply(def.resolve)
          else
            BWL.Services.Auth.BeginAuth(
              provider,
              configService.clientKey,
              'HTML',
              encodeURIComponent(returnURL),
              (profile) ->
                $window.location.href = profile.AuthURL
              (err) ->
                $rootScope.$apply(->
                  def.reject(err)
                )
            )
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise
    
    register : (account) ->
      def = $q.defer()

      account.PasswordHash = BWL.Plugins.MD5(account.Password) unless account.PasswordHash

      # request level 20 perms, this is for member
      BWL.Services.Account.Register(BWL.Models.DomainProfileRoleEnum.Member, account, 
        (result) ->
          $rootScope.$apply(def.resolve)
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
        )

      def.promise
    
    signin : (account) ->
      def = $q.defer()

      BWL.Services.Account.Logon(account, 
        ->
          $rootScope.$apply(def.resolve)
        (err, resp) ->
          $rootScope.$apply(->
            def.reject(resp.Message)
          )
      )

      def.promise

    
    signoff : ->
      def = $q.defer()
      
      UrlSaverService.clear()
      BWL.Services.Account.Logoff(->
        $rootScope.$apply(def.resolve)
      )

      def.promise
    
    loadAuthProviders : (cbk, errCbk) ->
      def = $q.defer()

      BWL.Services.Auth.ListAuthProviders(
        (providers) ->
          $rootScope.$apply(->
            def.resolve(providers)
          )
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise
    
authService.$inject = ['configService', '$q', '$rootScope', 'modelService', '$cookieStore', "$window", "UrlSaverService", "ProfileService"]