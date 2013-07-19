#= require BWL/data_access

console?.warn "Can't use BWL.Data without BWL module loaded" unless BWL?
console?.warn "Can't use BWL.Data without BWL.DataAccess module loaded" unless BWL.DataAccess?
console?.warn "Can't use BWL.Data without BWL.URL module loaded" unless BWL.URL?

class @BWL.Data
  @xhdList: []

  @InvokeService: (method, url, data, successCallback, errorCallback=BWL.Data.ServiceFailedCallback) ->
    method = method.toUpperCase()

    requestConfig = 
      url : url
      method : method

    if (method == "POST" || method == "PUT")
      contentType = "";

      # // if this is a JS object, convert to JSON, else just pass the data as
      # // form data
      if typeof data == 'object'
        contentType = "application/json";
        data = JSON.stringify(data);
      else
        contentType = "application/x-www-form-urlencoded";
      

      # // setup for posting data
      requestConfig.headers =
        "Content-Type" : contentType
        "Content-Length" : data.length
      
      requestConfig.data = data

    host = BWL.URL.getHost(url)
    xhd = @xhdList[host]

    unless xhd?
      xhd = new BWL.Plugins.easyXDM.Rpc({
          remote : host + "/embed/Plugins/easyXDM/cors.html",
        }, {
          remote : 
            request : {}
        })
      @xhdList[host] = xhd

    internalErrorCallback = (resp) =>
      BWL.Loading.Stop()
      console.warn "internalError", resp if console?
      msg = if resp.Message? then resp.Message else "Unkown Error"
      return if msg.substr(0, msg.length) == "Object reference not set to an instance of an object."

      if (msg == BWL.t('DataAccess.ServerMessage.401'))
        BWL.UI.Alert BWL.t("DataAccess.401")
        BWL.Common.eraseCookie(BWL.TokenName);
        window.location.href = BWL.URL.getRootURL();
      
      errorCallback?(BWL.t('DataAccess.Error', msg: msg), resp);

    # // send the request
    xhd.request(requestConfig,
      (resp) ->
        modelObj = JSON.parse(resp.data)
        
        if modelObj.Message == BWL.t("DataAccess.ServerMessage.OK", defaultValue:"OK")
          successCallback(BWL.DataAccess.JSON2Obj(modelObj.Object), modelObj)
        else
          internalErrorCallback(modelObj)
      (error) ->
        internalErrorCallback(modelObj)
    )
    
  @ServiceFailedCallback: (msg, response) ->
    BWL.UI.Alert "Service FAILURE: #{msg}"