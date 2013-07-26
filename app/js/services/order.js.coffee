OrderService = @prepTickets.factory('OrderService', ($q, $rootScope, configService) ->
  _orders = []
  _currentOrder = {}

  getOrderHistory: ->
    def = $q.defer()

    
    BWL.Services.Order.FindAllOrderHistory(
      (orders) ->
        _orders = orders
        $rootScope.$apply(def.resolve(orders))
      (err) ->
        $rootScope.$apply(def.reject(err))
    )
    
    def.promise

  getOrder: (storeKey, orderKey) ->
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

  getLatestOrder: ->
    def = $q.defer()

    @getOrderHistory().then(
      (orders) => 
        if (order = orders[0])
          @getOrder(order.StoreKey, order.Key).then(
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