console?.warn "Can't use BWL.UI without BWL module loaded" unless BWL?

class @BWL.UI
  @Alert: (msg) ->
    #TODO: Expand this with a better UI
    console.warn(msg) if console?
    alert(msg)