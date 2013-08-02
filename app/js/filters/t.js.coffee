# Custom locale/translation filter
@prepTickets.filter('t', [
  () ->
    # 
    # @todo detect client lang and use the appropiate resources file
    # @method t
    # @param {string} Value to translate
    # 
    (target, defaultValueOrOptions=target) ->
      options = {}
      if typeof defaultValueOrOptions is "object"
        options = defaultValueOrOptions
      else
        options.defaultValue = defaultValueOrOptions
      BWL.t(target, options)
])