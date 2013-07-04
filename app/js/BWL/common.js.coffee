#= require BWL/loading
throw "Can't use BWL.Common without BWL module loaded" unless BWL?

BWL.Common = 
  getHost: (url) ->    
    a = document.createElement("a")
    a.href = url

    if a.port != "0" && a.port != "80" && a.port != "443"
      a.protocol + "//" + a.hostname + ":" + a.port
    else
      a.protocol + "//" + a.hostname