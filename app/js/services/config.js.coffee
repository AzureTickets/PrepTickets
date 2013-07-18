# config service
@prepTickets.factory 'configService', ->
  # appName : '<%= at.name %>'
  clientKey : 'c31e42d6-9205-417d-a2d9-366abc7d5047'
  defaultDepth: 4
  multipleStores : false
  popupAuthWidth : 500
  popupAuthHeight : 500
  container : 
    store : '<%= at.name %>'
  typeahead : 
    minLength : 3
  cookies : 
    lastPath : 'authLastPath',
    loggedStatus : 'auth',
    storeKey : 'storeKey',
    paymentSessionKey : 'paymentSessionKey'
  api :
    stockLimit : 500