# authentication service
@prepTickets.factory 'authService', ['configService', '$q', '$rootScope', 'modelService', '$cookieStore',
  (configService, $q, $rootScope, modelService, $cookieStore) ->
    _clientKey = _domainProfile = null

    # 
    # Authenticate user
    # 
    # @param {object} $scope We're authenticating on the scope of a controller.
    # @returns
    # 
    authenticate: ($scope) ->
      _this = this
      def = $q.defer()

      if (@isDomainProfileReady())
        @loadProfile(configService.clientKey).then(
          =>
            $scope.DomainProfile = @getDomainProfile()
            $scope.$apply() unless $scope.$$phase
            def.resolve()
          (err) ->
            $scope.$apply( ->
              def.reject(err)
            )
        )
      else if @isDomainProfileReady()
        def.resolve()

      def.promise
    
    isAuthenticated : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Authenticated
    
    isMember : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Member
    
    isPublic : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Public
    
    isExplicit : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Explicit
    
    isStoreOwner : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.StoreOwner
    
    isEmployee : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Employee
    
    isService : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Service
    
    isAdministrator : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.Administrator
    
    isNoAccess : ->
      _domainProfile.ProfileRole == BWL.Models.DomainProfileRoleEnum.NoAccess
    
    hasStoreAccess : ->
      @isMember() || @isExplicit() || @isStoreOwner() || @isEmployee() || @isService() || @isAdministrator()
    
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
    
    loadProfile : (clientKey) ->
      def = $q.defer()

      BWL.ClientKey = clientKey
      _clientKey = clientKey

      BWL.Auth.LoadProfile(
        ->
          $rootScope.$apply(def.resolve)
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise
    
    logonByProvider : (provider) ->
      def = $q.defer()

      BWL.Auth.ClientKey = _clientKey
      BWL.Auth.PopupHeight = configService.popupAuthHeight
      BWL.Auth.PopupWidth = configService.popupAuthWidth

      BWL.Services.Account.GetProfile(
        (profile) ->
          if (profile.DomainProfileId != 0)
            $rootScope.$apply(def.resolve)
          else
            BWL.Auth.Logon(provider, 
              ->
                $rootScope.$apply(def.resolve)
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

      # request level 20 perms, this is for
      # store owners perms
      BWL.Services.Account.Register(20, account, 
        ->
          $rootScope.$apply(def.resolve)
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
        )

      def.promise
    
    logon : (account) ->
      def = $q.defer()

      BWL.Services.Account.Logon(account, 
        ->
          $rootScope.$apply(def.resolve)
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

      def.promise

    
    logoff : ->
      def = $q.defer()

      BWL.Services.Account.Logoff(->
        $rootScope.$apply(def.resolve)
      )

      def.promise
    
    getDomainProfile : ->
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

  ]