throw "Can't use BWL.DataAccess without BWL module loaded" unless BWL?
throw "BWL.Plugins.json2 required!" unless BWL.Plugins.json2?

BWL.DataAccess = 
  # Function to parse JSON to DOM Object
  JSON2Obj: (JSON) ->
    BWL.Plugins.json2.parse(JSON)
  