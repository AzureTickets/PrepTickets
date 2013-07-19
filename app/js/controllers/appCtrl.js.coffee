@prepTickets.controller('appCtrl', ["$rootScope", "errorService", "flash", ($rootScope, errorService, flash) ->
  $rootScope.errors = []
  $rootScope.$on 'flash:message', (_, messages, done) ->
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    errorService.log "Route Change Error: #{rejection}"
])