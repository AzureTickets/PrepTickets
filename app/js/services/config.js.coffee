# config service
@prepTickets.factory 'configService', ->
  appName : 'PrepTickets'
  clientKey : 'b31e42d6-9205-417d-a2d9-366abc7d5046'
  BingMapKey: 'AgPzPnVZziQw-UBNbXDqhANfg5fFYmDtaErGsuW_-KSjP3fJvvyYp5s5wjr-yxnT'
  defaultDepth: 4
  defaultStoreKey: 'prepTickets'
  typeahead : 
    minLength : 3
  cookies : 
    cart: "cart"
    lastPath : 'authLastPath',
    storeKey : 'storeKey',
