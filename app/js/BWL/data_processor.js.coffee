throw "Can't use BWL.data_processor without BWL module loaded" unless BWL?

#Module used to process any data returned from the server.
BWL.DataProcessor =
  #This is to be overwritten if user wants to do post processing on data coming from the server
  process: (data) ->
    BWL.Plugins.json2.parse(data)