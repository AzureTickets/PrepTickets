console?.warn "Can't use BWL.DataAccess without BWL module loaded" unless BWL?

class @BWL.DataAccess
  # Function to parse JSON to DOM Object
  @JSON2Obj: (data) ->
    JSON?.parse(data)
  @Obj2JSON: (obj) ->
    JSON?.stringify(obj)