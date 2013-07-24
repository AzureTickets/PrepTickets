CartService = @prepTickets.factory('CartService', ($cookieStore, storeService) ->
  _cart = {}

  count:(storeKey) ->
    storeKey = storeService.getCurrentStoreKey() unless storeKey?
    return 0 unless _cart[storeKey]
    sum = 0
    for item in _cart[storeKey]
      sum += item.quantity
    sum
  quantityFor:(storeKey, itemKey, itemType) ->
    return 0 unless _cart[storeKey]
    for item in _cart[storeKey]
      return item.quantity if item.key == itemKey
    return 0

  addItem: (storeKey, itemKey, itemType, quantity=1) ->
    _cart[storeKey] ?= []
    #TODO: update existing itemKey item?
    _cart[storeKey].push({key: itemKey, type: itemType, quantity: quantity})
)

CartService.$inject = ["$cookieStore", "storeService"]