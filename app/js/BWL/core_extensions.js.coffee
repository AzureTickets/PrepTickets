String.prototype.format = ->
  formatted = this
  for replaceValue, idx in arguments
    regexp = new RegExp("\\{#{idx}\\}", 'gi')
    formatted = formatted.replace(regexp, replaceValue)
  formatted

Array.prototype.last = ->
  this[this.length - 1]