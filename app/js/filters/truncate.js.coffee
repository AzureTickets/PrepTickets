@prepTickets.filter('characters', ->
  (input, chars, breakOnWord) ->
    return input if (isNaN(chars))
    return '' if (chars <= 0)
    if (input && input.length >= chars)
      input = input.substring(0, chars)

      unless breakOnWord
        lastspace = input.lastIndexOf(' ')
        input = input.substr(0, lastspace) if lastspace isnt -1
        
      else
        while (input.charAt(input.length - 1) is ' ')
          input = input.substr(0, input.length - 1)
      return input + '...'
    input
)
@prepTickets.filter('words', ->
  (input, words) ->
    return input if (isNaN(words))
    return '' if (words <= 0)
    if input
        inputWords = input.split(/\s+/)
        if inputWords.length > words
          input = inputWords.slice(0, words).join(' ') + '...';
    input
) 