BreadcrumbService = @prepTickets.factory('BreadcrumbService', ($cookieStore) ->
  _breadcrumbs = []

  add: (name, link, level) ->
    level = (_breadcrumbs.length) unless level?
    _breadcrumbs[level] = {name: name, link:link}
  addStore: (store) ->
    @clear()
    @add(store.Name, "#/school/#{store.URI}", 0)
  addEvent: (store, event) ->
    @clear()
    @addStore(store)
    @add(event.Name, "#/school/{store.URI}/event/#{event.CustomURI.URI}", 1)
  addCart: (store) ->
    @clear()
    @addStore(store)
    @add("Cart", "#/cart/#{store.Key}")
  addCartCheckout: (store) ->
    @addCart(store)
    @add("Checkout")
  addOrders: ->
    @clear()
    @add("Orders", "#/orders")
  addOrder: (order) ->
    @addOrders()
    @add("##{order.OrderId}", "#/orders/#{order.StoreKey}/#{order.Key}")
  addTicket: (order, ticket, idx) ->
    @addOrder(order)
    @add("Ticket #{idx} of #{order.InventoryItems.length}")
  addProfile: (profile) ->
    @clear()
    @add("Profile")
  addSignin: ->
    @clear()
    @add("Signin", "#/signin")
  addForgotPassword: ->
    @addSignin()
    @add("Forgot Password")
  clear: ->
    _breadcrumbs = []
  crumbs: -> 
    _breadcrumbs
)
BreadcrumbService.$inject = ["$cookieStore"]