throw "Can't use BWL.Loading without BWL module loaded" unless BWL?

#FIX: THIS IS JUST BAD! NEEDS TO BE RE-WRITTEN to be expandable
BWL.Loading =
  Start: (msg) ->
    msg = t("Common.Waiting") unless msg?

    #TODO: Finish
    console.warn "BWL.Loading.Start called but wasn't implemented" if console?

  Stop: ->
    console.warn "BWL.Loading.Stop called but wasn't implemented" if console?