# Modal System
# Used mainly to interact with user via some sort of modal
ModalService = @prepTickets.factory 'ModalService', ($window) ->
  confirm: (msg) ->
    $window.confirm msg
  alert: (msg) ->
    $window.alert msg

ModalService.$inject = ["$window"]