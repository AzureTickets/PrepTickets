CartService = @prepTickets.factory('CartService', ($cookieStore, storeService) ->
  _cart = []

  getCartObj: ->
    _cart

  addCart: (cart) ->
    @deleteCartForStore(cart.StoreKey)
    _cart.push(cart)

  deleteCartForStore: (key) ->
    idx = @findCartIndexForStore(key)
    _cart.splice(idx, 1) if idx > 1

  findCartForStore: (key) ->
    _cart[@findCartIndexForStore(key)]

  findCartIndexForStore: (key) ->
    for cart, idx in _cart
      return idx if cart.StoreKey == key
    return -1

  count: ->
    sum = 0
    for cart in _cart
      for key, item of cart.Items
        sum += item.Quantity
    sum

)

CartService.$inject = ["$cookieStore", "storeService"]