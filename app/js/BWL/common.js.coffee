#= require BWL/loading
throw "Can't use BWL.Common without BWL module loaded" unless BWL?

BWL.Common = 
  getHost: (url) ->    
    a = document.createElement("a")
    a.href = url
    port = if (a.port in ["", "0", "80", "433"]) then "" else ":#{a.port}"
    "#{a.protocol}//#{a.hostname}#{port}"