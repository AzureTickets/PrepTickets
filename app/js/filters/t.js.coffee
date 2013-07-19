# Custom locale/translation filter
@prepTickets.filter('t', [
  () ->
    # 
    # @todo detect client lang and use the appropiate resources file
    # @method t
    # @param {string} Value to translate
    # 
    (t, defaultValue=t) -> BWL.t(t, defaultValue:defaultValue)
])