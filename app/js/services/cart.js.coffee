CartService = @prepTickets.factory('CartService', ($cookieStore, storeService) ->
  _cart = {}

  getCartObj: ->
    _cart

  addCart: (cart) ->
    @dropQuantityZeroItems(cart)
    return _cart = cart if _cart.StoreKey != cart.StoreKey
    @updateItems(cart)
    _cart

  updateItems: (newCart) ->
    console.log "updating cart", _cart, newCart
    for key, item of newCart.Items
      if _cart.Items[key]?
        _cart.Items[key].Quantity += item.Quantity
      else
        _cart.Items[key] = item

  dropQuantityZeroItems: (cart) ->
    for key, item of cart.Items
      delete cart.Items[key] if item.Quantity == 0
    cart

  count: ->
    sum = 0
    for key, item of _cart.Items
      sum += item.Quantity
    sum

)

CartService.$inject = ["$cookieStore", "storeService"]