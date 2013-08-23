# Custom locale/translation filter
@prepTickets.filter('t', [
  () ->
    # 
    # @todo detect client lang and use the appropiate resources file
    # @method t
    # @param {string} Value to translate
    # 
    (target, defaultValueOrOptions) ->
      options = {}
      if typeof defaultValueOrOptions is "object"
        options = defaultValueOrOptions
      else
        options.defaultValue = if defaultValueOrOptions?
                                  defaultValueOrOptions
                                else
                                  target.split(".").join(" ")
      BWL.t(target, options)
])