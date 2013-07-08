unless BWL?
  console?.warn "Can't use BWL.Cookie without BWL module loaded" 

class BWL.Cookie
  # Write to cookie a value
  #
  # @example write cookie value
  #   BWL.Cookie.write('token-123', "myCoolValue", {})
  #
  # @param [String] token token name in cookie
  # @return [Object] value under that token. Might be null if nothing was written for that token.
  @read: (token)->
    BWL.$.cookie(token)

  # Write to cookie a value
  #
  # @example write cookie value
  #   BWL.Cookie.write('token-123', "myCoolValue", {})
  #
  # @param [String] token token name in cookie
  # @param [Object] value value to write in cookie
  # @option options [Number] expires seconds till cookie expires
  # @return [Object] value value that was just written.
  @write: (token, value, options={}) ->
    BWL.$.cookie(token, value, options)
    value