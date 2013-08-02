# authentication service
authService = @prepTickets.factory 'authService', (configService, $q, $rootScope, modelService, $cookieStore, $window, UrlSaverService) ->
    _domainProfile = {}

    # 
    # Authenticate user
    # 
    # @param {object} $scope We're authenticating on the scope of a controller.
    # @returns
    # 
    authenticate: ($scope) ->
      _this = this
      def = $q.defer()

      unless @isDomainProfileReady()
        @loadProfile().then(
          (profile) ->
            $scope.DomainProfile = _domainProfile = profile
            $scope.$apply() unless $scope.$$phase
            def.resolve(profile)
          (err) ->
            $scope.$apply( ->
              def.reject(err)
            )
        )
      else
        def.resolve()

      def.promise
    
    isSignedIn: ->
      _domainProfile.ProfileRole >= BWL.Models.DomainProfileRoleEnum.Authenticated
    isAuthenticated : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Authenticated
    
    isMember : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Member
    
    isPublic : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Public
    
    isExplicit : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Explicit
    
    isStoreOwner : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.StoreOwner
    
    isEmployee : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Employee
    
    isService : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Service
    
    isAdministrator : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.Administrator
    
    isNoAccess : ->
      _domainProfile.ProfileRole is BWL.Models.DomainProfileRoleEnum.NoAccess
    
    hasStoreAccess : ->
      @isMember() or @isExplicit() or @isStoreOwner() or @isEmployee() or @isService() or @isAdministrator()
    
    upgradeProfile : ->
      def = $q.defer()

      BWL.Services.Account.Signup(
        ->
          $rootScope.$apply(def.resolve)
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise
    
    loadProfile : () ->
      def = $q.defer()
      return def.resolve(_profile) if _profile?.Key
      BWL.Services.Account.GetProfile(
        (profile)->
          _domainProfile = profile
          $rootScope.$apply(def.resolve(profile))
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise
    
    signinByProvider : (provider, returnURL = $window.location.href) ->
      def = $q.defer()

      # BWL.Auth.ClientKey = _clientKey
      # BWL.Auth.PopupHeight = configService.popupAuthHeight
      # BWL.Auth.PopupWidth = configService.popupAuthWidth
      

      BWL.Services.Account.GetProfile(
        (profile) ->
          if (profile.DomainProfileId != 0)
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
      $rootScope.DomainProfile = {}
      UrlSaverService.clear()
      BWL.Services.Account.Logoff(->
        $rootScope.$apply(def.resolve)
      )

      def.promise
    
    getBlankProfile : ->
      _domainProfile = modelService.getInstanceOf('DomainProfile',
          null, 'Profile')
      _domainProfile
    
    setDomainProfile : (profile) ->
      BWL.Profile = profile
    
    getAccountProfile : ->
      obj = if BWL.Profile?.AccountProfile? 
              BWL.Profile.AccountProfile
            else 
              modelService.getInstanceOf('AccountProfile')
      # one exception where we modify modelsmeta
      # to hold a tmp field
      obj.Password = obj.Password?
      obj.ConfirmPassword = obj.ConfirmPassword?
      #FIX Why is this modifying the meta?
      BWL.Models.AccountProfile.Meta.Password = angular.copy(BWL.Models.AccountProfile.Meta.PasswordHash)
      BWL.Models.AccountProfile.Meta.ConfirmPassword = angular.copy(BWL.Models.AccountProfile.Meta.Password)
      obj
    
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
    
    isDomainProfileReady : ->
      @getDomainProfile().Key?
    
    isLogged : ->
      $cookieStore.get(configService.cookies.loggedStatus)?

authService.$inject = ['configService', '$q', '$rootScope', 'modelService', '$cookieStore', "$window", "UrlSaverService"]