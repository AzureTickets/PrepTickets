# error service
@prepTickets.factory 'errorService', ['$rootScope', ($rootScope) ->
        
        # Displays an error message.
        # 
        # @method log
        # @param modelName Model instance to retrieve
        log : (msg) ->
          $rootScope.errorMsg = msg
]