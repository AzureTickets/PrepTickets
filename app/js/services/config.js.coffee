# config service
@prepTickets.factory 'configService', ->
  # appName : '<%= at.name %>'
  clientKey : 'b31e42d6-9205-417d-a2d9-366abc7d5046'
  defaultDepth: 4
  multipleStores : false
  popupAuthWidth : 500
  popupAuthHeight : 500
  container : 
    store : 'prepTickets'
  typeahead : 
    minLength : 3
  cookies : 
    cart: "cart"
    lastPath : 'authLastPath',
    loggedStatus : 'auth',
    storeKey : 'storeKey',
    paymentSessionKey : 'paymentSessionKey'
  api :
    stockLimit : 500