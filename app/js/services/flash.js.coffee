flash = @prepTickets.factory 'flash', ($rootScope, $timeout) ->
  messages = []
  reset = null

  cleanup = ->
    $timeout.cancel(reset)
    reset = $timeout(-> messages = [])

  emit = ->
    $rootScope.$emit('flash:message', messages, cleanup)
  
  # $rootScope.$on('$routeChangeStart', cleanup)
  $rootScope.$on('$routeChangeSuccess', emit)

  asMessage = (level, text) ->
    unless text
      text = level
      level = 'success'
    
    level: level, text: text 

  flash = (level, text) -> 
    messages.push(asMessage(level, text))
    return flash
  flash.now = -> emit()
  flash.clear = -> cleanup(); emit();

  return flash

flash.$inject = ["$rootScope", "$timeout"]