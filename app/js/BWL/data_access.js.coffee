throw "Can't use BWL.DataAccess without BWL module loaded" unless BWL?

BWL.DataAccess = 
  # Function to parse JSON to DOM Object
  JSON2Obj: (data) ->
    JSON?.parse(data) || BWL.jQuery?.parseJSON(data) || throw "Can't parse JSON data due to a loack of a JSON engine"
  Obj2JSON: (obj) ->
    JSON?.stringify(obj) || BWL.jQuery?.parseJSON(data) || throw "Unable to stringify obj due to a lack of a JSON engine"