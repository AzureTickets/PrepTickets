# error service
@prepTickets.factory 'errorService', ['$rootScope', 'flash', ($rootScope, flash) ->
  # Displays an error message.
  # 
  # @method log
  # @param [String] message Message to log
  # @param [Boolean] display Will flash an error if set to true (default is true)

  log : (message, display=true) ->
    $rootScope.errors.push(message)
    flash('danger', message) if display
]