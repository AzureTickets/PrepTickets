# store service
@prepTickets.factory('storeService',
  [
      '$q',
      '$rootScope',
      'modelService',
      'configService',
      ($q, $rootScope, modelService, configService) ->
        _stores = []
        _lastAvailableURI = null

        searchStores: (query) ->
          def = $q.defer()

          BWL.Services.SearchIndex.SearchType("Store", query, "", "", 
            (stores) ->
              console.log stores
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
        
        hasStore : ->
          _stores?[0]?.Key?
        
        getStores : ->
          _stores
        
        getStore : ->
          modelService.getInstanceOf('Store')
        
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
        
        getURISuggestion : (suggestion, count, def) ->
          def ?= $q.defer()
          # // check URI availability and regenerate if exists
          count ?= 0
          maxCount = 20
          suggestion = if count > 0 then suggestion + String.valueOf(count) else suggestion

          @getStoreKeyByURI(suggestion).then(
            (storeKey) =>
              if (storeKey? != '')
                # existing URI, generate extra string
                return @getURISuggestion(suggestion, count++, def) unless (maxCount > count)
                def.reject(BWL.t('System.Error', msg: 'maximum iteration achieved'))
               else
                # URI not found, proceed to creation
                def.resolve(h)
              
           (err) ->
             def.reject(err)
          )

          def.promise
        
        createStore : (store) ->
          def = $q.defer()

          BWL.Services.Model.Create(
            configService.container.store, @getStore().Type,
            store, (storeKey) ->
              $rootScope.$apply(->
                def.resolve(storeKey)
              )
            (err) ->
              $rootScope.$apply(->
                def.reject(err)
              )
            )

          def.promise
        
        initStore: (storeKey) ->
          def = $q.defer()

          BWL.Services.Model.Read(
            configService.container.store
            "Store"
            storeKey
            configService.defaultDepth
            (store) ->
              store.Address = modelService.getInstanceOf('Address') unless store.Address?
              store.URI = store.StoreURIs?[0]?.URI

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
              

              unless angular.isArray(store.PaymentProviders) || store.PaymentProviders.length == 0
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
        
        addStoreURI: (storeKey, uri) ->
          def = $q.defer()

          BWL.Services.Model.Create(storeKey, "StoreURI",
            URI: uri
            (uriKey) ->
              BWL.Services.Model.Add(
                configService.container.store
                "Store" 
                storeKey
                "StoreURIs"
                BWL.Model.StoreURI.Type
                uriKey
                (ret) ->
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
        
        #FIXME: Change P to something that makes sense
        addPaymentProvider : (store, p) ->
          def = $q.defer()

          delete p.Type
          delete p.Key

          BWL.Services.Model.Add(
            store.Key
            BWL.Model.Store.Type 
            store.Key 
            'PaymentProviders'
            BWL.Model.PaymentProvider.Type
            p 
            (ret) ->
              $rootScope.$apply(->
                def.resolve(ret)
              )
           (err) ->
              $rootScope.$apply(->
                def.reject(err)
              )
          )

          def.promise
        
        removePaymentProvider : (store, ix) ->
          def = $q.defer()

          if store.PaymentProviders?
            BWL.Services.Model.Remove(
              store.Key
              'Store'
              store.Key
              'PaymentProviders'
              BWL.Model.PaymentProvider.Type
              store.PaymentProviders[ix].Key
              (ret) ->
                $rootScope.$apply(->
                  def.resolve(ret)
                )
              (err) ->
                $rootScope.$apply(->
                  def.reject(err)
                )
            )
          else
            def.resolve()
          

          def.promise
        
        addEvent : (storeKey, eventKey) ->
          def = $q.defer()

          BWL.Services.Model.Add(
            storeKey
            BWL.Model.Store.Type
            storeKey
            'Events',
            BWL.Model.Event.Type
            Key: eventKey
            (ret) ->
              $rootScope.$apply(->
                def.resolve(ret)
              )
            (err) ->
              $rootScope.$apply(->
                def.reject(err)
              )
          )

          return def.promise
        
        updateStore : (store) ->
          def = $q.defer() 
          tmpStore = angular.copy(store)
          _store = angular.copy(store)

          delete tmpStore.Address
          delete tmpStore.StoreURIs
          delete tmpStore.isNew
          delete tmpStore.PaymentProviders
          delete tmpStore.tmpPaymentProvider

          BWL.Services.Model.Update(
              configService.container.store 
              'Store'
              _store.Key
              tmpStore
              (ret) ->
                $rootScope.$apply(->
                  def.resolve(_store)
                )
              (err) ->
                $rootScope.$apply(->
                  def.reject(err)
                )
            )

          def.promise
  ])