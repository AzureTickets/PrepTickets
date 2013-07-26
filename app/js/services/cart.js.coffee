CartService = @prepTickets.factory('CartService', (storeService, $cookieStore, configService) ->
  _cart = {}

  getCartObj: (storeKey)->
    @load(storeKey)
    _cart

  addCart: (cart) ->
    if _cart.StoreKey != cart.StoreKey
      @replaceCart(cart)
    else
      @dropQuantityZeroItems(cart)
      @updateItems(cart)
      @save()
    _cart

  replaceCart: (cart) ->
    @dropQuantityZeroItems(cart)
    _cart = cart 
    @save()
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

  count: (storeKey) ->
    @load(storeKey)
    sum = 0
    for key, item of _cart.Items
      sum += item.Quantity
    sum

  save: ->
    console.log "Saving cart #{_cart?.StoreKey}", _cart
    return false unless _cart?.StoreKey
    $cookieStore.put("#{configService.cookies.cart}:#{_cart.StoreKey}", JSON.stringify(_cart))
  load: (storeKey)->
    return _cart = {} unless storeKey?
    return _cart if _cart?.StoreKey? is storeKey
    console.log _cart.StoreKey, storeKey
    console.log "Loading cart for store: #{storeKey}"
    _cart = JSON.parse($cookieStore.get("#{configService.cookies.cart}:#{storeKey}"))
    console.log _cart
  pushToServer: ->
    
)

CartService.$inject = ["storeService", "$cookieStore", "configService"]