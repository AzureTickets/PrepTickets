@prepTickets.controller('appCtrl', ["$rootScope", "errorService", "flash", ($rootScope, errorService, flash) ->
  $rootScope.errors = []
  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    console.warn rejection if console?
    errorService.log "Route Change Error: #{rejection}"
])