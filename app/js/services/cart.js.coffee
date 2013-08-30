CartService = @prepTickets.factory('CartService', (storeService, $cookieStore, configService, ServerCartService) ->
  _cart = {}
  
  getCartObj: (storeKey)->
    @load(storeKey)

  buildTempCart: (store, event) ->
    return unless store
    cart = 
      StoreKey: store.Key
      StoreName: store.Name
      PaymentType: store.PaymentProviders[0]?.ProviderType
      FeeAmount: store.PerItemFee?.Amount || 0
      ShippingAmount: 0 #TODO: Need to figure out how this works
      Items: {}

    if event
      for item in event.Items
        cart.Items[item.Key] =
          Quantity: 0
          EventKey: event.Key
          EventName: event.Name
          Key: item.Key
          Type: item.Type
          Name: item.Name
          Price: item.Price.ItemPrice
    
    cart

  addCart: (cart) ->
    if _cart.StoreKey isnt cart.StoreKey
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

  clear: (storeKey)->
    storeKey = _cart.StoreKey unless storeKey?
    @remove(storeKey)
    _cart = {}

  updateItems: (newCart) ->
    for key, item of newCart.Items
      if _cart.Items[key]?
        _cart.Items[key].Quantity += item.Quantity
      else
        _cart.Items[key] = item

  dropQuantityZeroItems: (cart=_cart) ->
    for key, item of cart.Items
      delete cart.Items[key] if item.Quantity == 0
    cart

  removeItem: (key) ->
    delete _cart.Items[key] if _cart.Items?[key]

  count: (storeKey) ->
    @load(storeKey)
    sum = 0
    for key, item of _cart.Items
      sum += item.Quantity
    sum

  save: ->
    return false unless _cart?.StoreKey
    $cookieStore.put("#{configService.cookies.cart}:#{_cart.StoreKey}", JSON.stringify(_cart))
  load: (storeKey)->
    return _cart = {} unless storeKey?
    return _cart if _cart?.StoreKey is storeKey
    cartString = $cookieStore.get("#{configService.cookies.cart}:#{storeKey}")
    _cart = JSON.parse(cartString) if cartString
    _cart
  remove: (storeKey)->
    return false unless storeKey 
    $cookieStore.remove("#{configService.cookies.cart}:#{storeKey}")
    true
  sendToServer: ->
    ServerCartService.upload(_cart)
    
)

CartService.$inject = ["storeService", "$cookieStore", "configService", "ServerCartService"]