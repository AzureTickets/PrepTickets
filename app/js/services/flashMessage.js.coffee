flash = @prepTickets.factory 'flash', ($rootScope, $timeout) ->
  messages = []
  reset = null

  cleanup = ->
    $timeout.cancel(reset)
    reset = $timeout(-> messages = [])

  emit = ->
    $rootScope.$emit('flash:message', messages, cleanup)
  
  $rootScope.$on('$routeChangeStart', cleanup)
  $rootScope.$on('$routeChangeSuccess', emit)

  asMessage = (level, text) ->
    unless text
      text = level
      level = 'success'
    
    level: level, text: text 

  return (level, text) -> emit(messages.push(asMessage(level, text)))

flash.$inject = ["$rootScope", "$timeout"]