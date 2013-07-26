# store service
storeService = @prepTickets.factory('storeService', ($q, $rootScope, modelService, configService, $cookieStore) ->
  _stores = []
  _currentStore = modelService.getInstanceOf('Store')
  _lastAvailableURI = null

  searchStores: (query) ->
    def = $q.defer()

    BWL.Services.SearchIndex.SearchType("Store", query, "", "", 
      (stores) ->
        _stores = if angular.isArray(stores) then stores else []

        $rootScope.$apply(->
          def.resolve(_stores)
        )
      (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )

    def.promise

  cacheTheKey: (key) ->
    $cookieStore.put($rootScope.config.cookies.storeKey, key)
    key
  isSameAsCachedKey: (key) ->
    key? && @getCachedKey() == key
  clearTheKey: () ->
    $cookieStore.remove($rootScope.config.cookies.storeKey)
  getCachedKey: () ->
    $cookieStore.get($rootScope.config.cookies.storeKey)

  listStores : (levels) ->
    def = $q.defer()

    BWL.Services.Store.ListStores(levels, 
      (stores) ->
        _stores = angular.isArray(stores) ? stores : []

        $rootScope.$apply(->
          def.resolve()
        )
      (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )

    def.promise
  
  getStores : ->
    _stores

  clearSearch: ->
    _stores = []
  
  getStore : (storeKey) ->
    def = $q.defer()
    storeKey = @getCachedKey() unless storeKey?
    def.resolve(_currentStore) if _currentStore?.storeKey == storeKey
    @initStore(storeKey).then(
      (store) -> 
        _currentStore = store
        def.resolve(store)
      (err) -> def.reject(err)
    )
    def.promise

  clearStore: ->
    @clearTheKey()
    _currentStore = null

  getBlankStore : ->
    modelService.getInstanceOf('Store')

  getCurrentStoreKey: ->
    return _currentStore.Key if _currentStore
    return getCachedKey()

  # 
  # Find for existent URIs.
  # 
  # @param uri URI
  # @returns {void}
  # 
  getStoreKeyByURI : (uri) ->
    def = $q.defer()
    BWL.Services.Store.FindStoreKeyFromCustomURI(
      uri
      (storeKey) ->
        _lastAvailableURI = uri if storeKey?.trim() == ''
        $rootScope.$apply(->
          def.resolve(storeKey)
        )
      (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )

    def.promise

  getStoreByURI: (uri) ->
    def = $q.defer()
    if _currentStore.URI == uri
      def.resolve(_currentStore) 
    else
      BWL.Services.Store.FindStoreKeyFromCustomURI(
        uri
        (storeKey) =>
          _lastAvailableURI = uri if storeKey?.trim() == ''
          def.resolve(@getStore(storeKey))
        (err) ->
          $rootScope.$apply(->
            def.reject(err)
          )
      )

    def.promise
  
  initStore: (storeKey) ->
    def = $q.defer()

    if _currentStore.Key == storeKey
      def.resolve(_currentStore)
    else
      BWL.Services.Model.Read(
        configService.container.store
        "Store"
        storeKey
        10
        (store) ->
          store.Address = modelService.getInstanceOf('Address') unless store.Address?
          store.URI = store.StoreURIs?[0]?.URI
          _currentStore = store

          _finishes = ->
            BWL.Services.Geo.ReadCurrency(
                store.Currency, 
                (currency) ->
                  $rootScope.$apply(->
                    def.resolve(store, currency)
                  )
                (err) ->
                  $rootScope.$apply(->
                    def.reject(err)
                  )
                )
          

          unless angular.isArray(store.PaymentProviders) && store.PaymentProviders.length == 0
            _finishes()
          else 
            # we handle only one PaymentProvider per Store
            BWL.Services.Model
                .Read(
                  store.Key,
                  'PaymentProvider',
                  store.PaymentProviders[0].Key,
                  1,
                  (paymentProvider) ->
                    store.PaymentProviders[0] = paymentProvider
                    _finishes()
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
  
  getCurrencies: ->
    def = $q.defer()

    BWL.Services.Geo.ListCurrencies(
      (currencies) ->
        $rootScope.$apply(->
          def.resolve(currencies)
        )
      (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )

    def.promise
  
  getPaymentProvidersByCurrency: (currency) ->
    def = $q.defer()

    BWL.Services.Payment.ListProvidersByCurrency(currency, 
      (paypros) ->
        $rootScope.$apply(->
          def.resolve(paypros)
        )
     (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )
    def.promise
  
  getPaymentProviderInfo: (providerType) ->
    def = $q.defer()

    BWL.Services.Payment.FindProviderInfoByType(
      providerType, 
      (info) ->
        $rootScope.$apply(->
          def.resolve(info)
        )
      (err) ->
        $rootScope.$apply(->
          def.reject(err)
        )
    )

    def.promise
  )

storeService.$inject = ['$q', '$rootScope', 'modelService', 'configService', '$cookieStore']