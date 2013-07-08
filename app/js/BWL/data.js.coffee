#= require BWL/data_access

console?.warn "Can't use BWL.Data without BWL module loaded" unless BWL?
console?.warn "Can't use BWL.Data without BWL.DataAccess module loaded" unless BWL.DataAccess?
console?.warn "Can't use BWL.Data without BWL.URL module loaded" unless BWL.URL?

class @BWL.Data
  @xhdList: []

  @InvokeService: (method, url, data, successCallback, errorCallback=BWL.Data.ServiceFailedCallback) ->
    method = method.toUpperCase()

    if method == "POST" || method == "PUT"
      # if this is a JS object, convert to JSON, else just pass the data as form data
      if typeof (data) == 'object' 
        contentType = "application/json";
        data        = BWL.DataAccess.Obj2JSON(data);
      else
        contentType = "application/x-www-form-urlencoded"
      

    host = BWL.URL.getHost(url)

    internalErrorCallback = (resp) =>
      BWL.Loading.Stop()

      return if resp.Message.substr(0, resp.Message.length) == "Object reference not set to an instance of an object."

      if (error.message == BWL.t('DataAccess.ServerMessage.401'))
        BWL.UI.Alert BWL.t("DataAccess.401")
        BWL.Common.eraseCookie(BWL.TokenName);
        window.location.href = BWL.URL.getRootURL();
      
      errorCallback?(BWL.t('DataAccess.Error', msg: resp.Message), resp);

    
    xhd = new BWL.$.ajax(
      url: url
      method: method
      type:'json'
      data: data if data?
      crossOrigin: true
      success: (resp) =>
        if resp.Message == BWL.t("DataAccess.ServerMessage.OK")
          # the request worked, return the object
          successCallback?(BWL.DataAccess.JSON2Obj(resp.Object), resp)
        else 
          internalErrorCallback(resp)
      error: (resp) =>
        internalErrorCallback(resp)

    )
  @ServiceFailedCallback: (msg, response) ->
    BWL.UI.Alert "Service FAILURE: #{msg}"