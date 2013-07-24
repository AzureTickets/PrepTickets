CartService = @prepTickets.factory('CartService', ($cookieStore, storeService) ->
  _cart = []

  getCartObj: ->
    _cart

  addCart: (cart) ->
    @deleteCartForStore(cart.StoreKey)
    _cart.push(cart)

  deleteCartForStore: (key) ->
    idx = @findCartIndexForStore(key)
    delete _cart.splice(idx, 1) if idx > 1

  findCartForStore: (key) ->
    _cart[@findCartIndexForStore(key)]

  findCartIndexForStore: (key) ->
    for cart, idx in _cart
      return idx if cart.StoreKey == key
    return -1

  count: ->
    sum = 0
    for cart in _cart
      for item in cart.Items
        sum += item.quantity
    sum
  quantityFor:(storeKey, itemKey, itemType) ->
    idx = findCartIndexForStore[storeKey]
    return 0 if idx < 0
    for item in _cart[idx].Items
      return item.quantity if item.key == itemKey
    return 0

  addItem: (storeKey, itemKey, itemType, quantity=1) ->
    console.log "Adding item", storeKey, itemKey, itemType, quantity
    return if quantity = 0
    _cart[storeKey] ?= []
    #TODO: update existing itemKey item?
    _cart[storeKey].push({key: itemKey, type: itemType, quantity: quantity})
)

CartService.$inject = ["$cookieStore", "storeService"]