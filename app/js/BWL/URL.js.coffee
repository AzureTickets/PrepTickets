throw "Can't use BWL.URL without BWL module loaded" unless BWL?

BWL.URL =
  getHost: (url) ->    
    a = document.createElement("a")
    a.href = url
    if (a.port in ["", "0", "80", "433"])
      "#{a.protocol}//#{a.hostname}"
    else
      "#{a.protocol}//#{a.hostname}:#{a.port}"

  getRootURL: ->
    @getHost(@getWindowLocation())

  getWindowLocation: ->
    window.location.toString()