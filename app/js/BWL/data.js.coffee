#= require BWL/data_access
#= require BWL/data_processor

throw "Can't use BWL.Data without BWL module loaded" unless BWL?
throw "Can't use BWL.Data without BWL.DataAccess module loaded" unless BWL.DataProcessor?
throw "Can't use BWL.Data without BWL.DataProcessor module loaded" unless BWL.DataProcessor?

@BWL.Data = 
  xhdList: []

  InvokeService: (method, url, data, successCallback, errorCallback=BWL.Data.ServiceFailedCallback) ->
    method = method.toUpperCase()

    # the default config is a simple request
    requestConfig = {
      url
      method
    }

    if method == "POST" || method == "PUT"
      # if this is a JS object, convert to JSON, else just pass the data as form data
      if typeof (data) == 'object' 
        contentType = "application/json";
        data        = BWL.Plugins.json2.stringify(data);
      else
        contentType = "application/x-www-form-urlencoded"
      
      # setup for posting data
      requestConfig.headers = 
        "Content-Type": contentType
        "Content-Length": data.length
      requestConfig.data = data;

    host = BWL.Common.getHost(url)
    xhd = this.xhdList[host]

    unless (xhd)
      xhd = new BWL.Plugins.easyXDM.Rpc(
        {remote: host + "/embed/plugins/easyXDM/cors.html"},
        remote:
          request: {}
        )
      this.xhdList[host] = xhd;

    # send the request
    xhd.request(
      requestConfig
      # success
      (rpcdata) ->
        modelObj = BWL.DataAccess.JSON2Obj(rpcdata.data)
        if modelObj.Message == BWL.t("DataAccess.ServerMessage.OK")
          # the request worked, return the object
          successCallback?(BWL.DataProcessor.process(modelObj.Object), modelObj)
        else 
          # there was a server error, alert the message
          BWL.Loading.Stop();
          return if modelObj.Message.substr(0, modelObj.Message.length) == "Object reference not set to an instance of an object."
          errorCallback?(BWL.t('DataAccess.Error', msg: modelObj.Message), modelObj);
        
      # error
      (error) ->
        BWL.Loading.Stop()

        if (error.message == BWL.t('DataAccess.ServerMessage.401'))
          BWL.UI.Alert BWL.t("DataAccess.401"), ->
            BWL.Common.eraseCookie(BWL.TokenName);
            #goto root
            window.location.href = BWL.Common.getRootURL();
        else
          errorCallback?(BWL.t("DataAccess.Error", msg: error.message))
    )
  ServiceFailedCallback: (msg, response) ->
    console.warn "FAILURE: #{msg}" if console?