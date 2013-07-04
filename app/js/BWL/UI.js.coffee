throw "Can't use BWL.UI without BWL module loaded" unless BWL?

BWL.UI = 
  Alert: (msg) ->
    #TODO: Expand this with a better UI
    console.warn(msg) if console?
    alert(msg)