OrderService = @prepTickets.factory('OrderService', ($q, $rootScope, configService) ->
  _orders = []
  _currentOrder = {}

  getAll: ->
    def = $q.defer()

    BWL.Services.Order.FindAllOrderHistory(
      (orders) ->
        _orders = orders
        $rootScope.$apply(def.resolve(orders))
      (err) ->
        $rootScope.$apply(def.reject(err))
    )
    
    def.promise

  get: (storeKey, orderKey) ->
    def = $q.defer()

    if _currentOrder.Key is orderKey
      def.resolve(_currentOrder) 
    else
      BWL.Services.Model.Read(
        storeKey
        "Order"
        orderKey 
        configService.defaultDepth
        (order) ->
          _currentOrder = order
          $rootScope.$apply(def.resolve(order))
        (err) ->
          $rootScope.$apply(def.reject(err))
      )


    def.promise

  getLatest: ->
    def = $q.defer()

    @getAll().then(
      (orders) => 
        if (order = orders[orders.length - 1])
          @get(order.StoreKey, order.Key).then(
            (order) ->
              def.resolve(order)
            (err) ->
              def.reject(err)
          )
      (err) ->
        def.reject(err)
    )

    def.promise
)

OrderService.$inject = ["$q", "$rootScope", "configService"]