profileService = @prepTickets.factory 'ProfileService', ($rootScope, $q, configService) ->
  _profile = {}
  get : (force = false) ->
    def = $q.defer()
    _profile = {} if force
    if _profile?.DomainProfileId and _profile?.DomainProfileId isnt 0
      def.resolve(_profile)
    else
      BWL.Services.Account.GetProfile(
        (profile) ->
          _profile = profile
          $rootScope.$apply(
            def.resolve(profile)
          )
        (err) ->
          $rootScope.$apply(
            def.reject(err)
          )
      )

    def.promise

  clear: ->
    _profile = {}

  accessToken: ->
    _profile.AccessToken?.Key

  signedInViaOAuth: ->
    return false unless _profile?
    _profile.AccessToken?.ProviderType isnt "Accounts"

  saveContact: (contact) ->
    def = $q.defer()

    BWL.Services.Model.Update(
      configService.clientKey
      "Contact"
      _profile.Contact.Key
      contact
      (contact) ->
        $rootScope.$apply def.resolve(contact)
      (err) ->
        $rootScope.$apply def.reject(err)
    )

    def.promise

  savePassword: (newPassword) ->
    def = $q.defer()
    passwordHash = BWL.Plugins.MD5(newPassword)
    BWL.Services.Account.ChangePassword(
      passwordHash
      {
        Email:_profile.Contact.EmailAddress
        PasswordHash: passwordHash
      }
      (result) ->
        $rootScope.$apply def.resolve(result)
      (err) ->
        $rootScope.$apply def.reject(err)
    )

    def.promise


profileService.$inject = ["$rootScope", "$q", "configService"]