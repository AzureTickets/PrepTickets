@prepTickets.controller('appCtrl', ["$rootScope", "errorService", "flash", ($rootScope, errorService, flash) ->
  $rootScope.$on 'flash:message', (_, messages, done) ->
    console.log "Settings scope to:", messages
    $rootScope.messages = messages
    done()
  
  $rootScope.$on "$routeChangeError", (event, current, previous, rejection) ->
    flash 'danger', "Route Change Error: #{rejection}"
])