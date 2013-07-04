String.prototype.format = ->
  formatted = this
  for replaceValue, idx in arguments
    regexp = new RegExp("\\{#{idx}\\}", 'gi')
    formatted = formatted.replace(regexp, replaceValue)
  formatted
