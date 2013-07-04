throw "Can't use BWL.Services without BWL module loaded" unless BWL?

BWL.Services = {} unless BWL.Services?

BWL.Services.Account = 
  GetProfile: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/account.svc/me", null, successCallback, errorCallback)

  Register: (requestedRole, objAccount, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/register/{0}".format(requestedRole, objAccount)
    BWL.InvokeService("POST", uri, objAccount, successCallback, errorCallback)
    
  Logon: (objAccount, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/logon".format(objAccount)
    BWL.InvokeService("POST", uri, objAccount, successCallback, errorCallback)
    
  Logoff: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/account.svc/logoff", null, successCallback, errorCallback)
    
  Signup: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/account.svc/signup", null, successCallback, errorCallback)
    
  ChangePassword: (newPasswordHash, objAccount, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/changepass/{0}".format(newPasswordHash, objAccount)
    BWL.InvokeService("POST", uri, objAccount, successCallback, errorCallback)
    
  ResetPassword: (objAccount, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/resetpass".format(objAccount)
    BWL.InvokeService("POST", uri, objAccount, successCallback, errorCallback)
    
  AccessRequest: (type, key, requestedAccess, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/access/request/{0}/{1}/{2}".format(type, key, requestedAccess)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AccessRequestFor: (type, key, profileKey, requestedAccess, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/access/requestfor/{0}/{1}/{2}/{3}".format(type, key, profileKey, requestedAccess)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AccessAdd: (type, key, profileKey, access, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/access/add/{0}/{1}/{2}/{3}".format(type, key, profileKey, access)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AccessPending: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/account.svc/access/pending", null, successCallback, errorCallback)
    
  AccessApprove: (key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/access/approve/{0}".format(key)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AccessReject: (key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/account.svc/access/reject/{0}".format(key)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)



BWL.Services.Accounts = 
  Root: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/accounts.svc/", null, successCallback, errorCallback)
    
  GetProfile: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/accounts.svc/me", null, successCallback, errorCallback)
    
  Register: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/register?session={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  VerifyEmail: (email, approveToken, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/verify/{1}?email={0}".format(email, approveToken)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ApproveRegister: (email, approveToken, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/register/{1}?email={0}".format(email, approveToken)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Logon: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/logon?session={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Logoff: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/accounts.svc/logoff", null, successCallback, errorCallback)
    
  Signup: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/signup?session={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ChangePassword: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/changepass?session={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ResetPassword: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/resetpass?session={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ApproveResetPassword: (email, approveToken, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/resetpass/{1}?email={0}".format(email, approveToken)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Authorize: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/authorize/{0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AuthorizeApprove: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/authorize/approve/{0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  AuthorizeCancel: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/accounts.svc/authorize/cancel/{0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)



BWL.Services.Auth = 
  ListAuthProviders: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/auth.svc/providers", null, successCallback, errorCallback)
  
  BeginAuth: (providerName, clientKey, display, redirectURL, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/authorize?providerName={0}&clientKey={1}&display={2}&redirectURL={3}".format(providerName, clientKey, display, redirectURL)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  GetSessionState: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/sessionState/{0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  GetTokenState: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/auth.svc/tokenState", null, successCallback, errorCallback)
    
  GetToken: (sessionKey, clientKey, clientSecret, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/getToken?sessionKey={0}&clientKey={1}&clientSecret={2}".format(sessionKey, clientKey, clientSecret)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  CancelAuth: (sessionKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/cancel?sessionKey={0}".format(sessionKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Logon: (providerName, clientKey, display, redirectURL, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/logon?providerName={0}&clientKey={1}&display={2}&redirectURL={3}".format(providerName, clientKey, display, redirectURL)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Logoff: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/auth.svc/logoff", null, successCallback, errorCallback)
    
  AddLogon: (providerName, clientKey, display, redirectURL, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/addLogon?providerName={0}&clientKey={1}&display={2}&redirectURL={3}".format(providerName, clientKey, display, redirectURL)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  RemoveLogon: (AuthProfileKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/auth.svc/removeLogon/{0}".format(AuthProfileKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Cart = 
  AddItems: (storeKey, itemTypeName, itemKey, quantity, options, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}/{1}/{2}/{3}".format(storeKey, itemTypeName, itemKey, quantity, options)
    BWL.InvokeService("PUT", uri, options, successCallback, errorCallback)
    
  AddAddress: (storeKey, addressKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}/{1}".format(storeKey, addressKey)
    BWL.InvokeService("PUT", uri, null, successCallback, errorCallback)
    
  RemoveItems: (storeKey, itemTypeName, itemKey, quantity, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}/{1}/{2}/{3}".format(storeKey, itemTypeName, itemKey, quantity)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  GetCart: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  HasCart: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}/hascart".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ClearCart: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/cart.svc/{0}".format(storeKey)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback); 


BWL.Services.Download = 
  DownloadFile: (storeKey, itemType, itemKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/download.svc/{0}/file/{1}/{2}".format(storeKey, itemType, itemKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  DownloadTicket: (storeKey, inventoryType, inventoryKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/download.svc/{0}/ticket/{1}/{2}".format(storeKey, inventoryType, inventoryKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  DownloadTickets: (storeKey, inventoryType, inventoryKeys, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/download.svc/{0}/tickets/{1}/{2}".format(storeKey, inventoryType, inventoryKeys)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  DownloadQRCode: (storeKey, inventoryType, inventoryKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/download.svc/{0}/qrcode/{1}/{2}".format(storeKey, inventoryType, inventoryKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Inventory = 
  AddInventoryItems: (storeKey, type, key, quantity, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/inventory.svc/{0}/{1}/{2}/{3}".format(storeKey, type, key, quantity)
    BWL.InvokeService("PUT", uri, null, successCallback, errorCallback)
    
  RemoveInventoryItems: (storeKey, type, key, quantity, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/inventory.svc/{0}/{1}/{2}/{3}".format(storeKey, type, key, quantity)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  GetInventoryStats: (storeKey, type, key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/inventory.svc/{0}/{1}/{2}".format(storeKey, type, key)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.MediaLibrary = 
  CropResizeImage: (storeKey, key, objImageCropResize, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/medialibrary.svc/{0}/image/crop/{1}".format(storeKey, key, objImageCropResize)
    BWL.InvokeService("POST", uri, objImageCropResize, successCallback, errorCallback)
    
  ListImages: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/medialibrary.svc/{0}/images".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  DeleteImage: (storeKey, key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/medialibrary.svc/{0}/image/{1}".format(storeKey, key)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  ListFiles: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/medialibrary.svc/{0}/files".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  DeleteFile: (storeKey, key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/medialibrary.svc/{0}/file/{1}".format(storeKey, key)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback); 

BWL.Services.Message = 
  GetMessagesProviders: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/message.svc/providers", null, successCallback, errorCallback)
    
  SendMessage: (storeKey, messagesProvider, objMessage, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/message.svc/{0}/{1}".format(storeKey, messagesProvider, objMessage)
    BWL.InvokeService("POST", uri, objMessage, successCallback, errorCallback)
    
  SendStoreAdminMessage: (storeKey, objMessage, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/message.svc/{0}/storeadmin".format(storeKey, objMessage)
    BWL.InvokeService("POST", uri, objMessage, successCallback, errorCallback)
    
  SendAdminMessage: (storeKey, objMessage, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/message.svc/{0}/admin".format(storeKey, objMessage)
    BWL.InvokeService("POST", uri, objMessage, successCallback, errorCallback); 

BWL.Services.Model = 
  Create: (storeKey, type, obj, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}".format(storeKey, type, obj)
    BWL.InvokeService("POST", uri, obj, successCallback, errorCallback)
    
  Read: (storeKey, type, key, levels, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}/{3}".format(storeKey, type, key, levels)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Update: (storeKey, type, key, obj, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}".format(storeKey, type, key, obj)
    BWL.InvokeService("PUT", uri, obj, successCallback, errorCallback)
    
  Delete: (storeKey, type, key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}".format(storeKey, type, key)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  Add: (storeKey, type, key, property, addType, addObject, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}/{3}/{4}".format(storeKey, type, key, property, addType, addObject)
    BWL.InvokeService("PUT", uri, addObject, successCallback, errorCallback)
    
  Get: (storeKey, type, key, property, levels, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}/{3}/{4}".format(storeKey, type, key, property, levels)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Remove: (storeKey, type, key, property, removeType, removeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}/{2}/{3}/{4}/{5}".format(storeKey, type, key, property, removeType, removeKey)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  List: (storeKey, type, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/{1}?p={2}".format(storeKey, type, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  Find: (storeKey, type, page, obj, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/find/{1}?p={2}".format(storeKey, type, page, obj)
    BWL.InvokeService("POST", uri, obj, successCallback, errorCallback)
    
  ImportFromPOST: (storeKey, type, obj, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/import/{1}".format(storeKey, type, obj)
    BWL.InvokeService("POST", uri, obj, successCallback, errorCallback)
    
  ImportFromURL: (storeKey, type, url, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/model.svc/{0}/import/{1}?url={2}".format(storeKey, type, url)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Order = 
  ProcessOrder: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/order.svc/{0}/process".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SetOrderState: (storeKey, orderKey, orderState, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/order.svc/{0}/{1}/{2}".format(storeKey, orderKey, orderState)
    BWL.InvokeService("PUT", uri, null, successCallback, errorCallback)
    
  FindOrders: (storeKey, orderState, startDate, endDate, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/order.svc/{0}/{1}?startdate={2}&enddate={3}".format(storeKey, orderState, startDate, endDate)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindOrderHistory: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/order.svc/{0}/history".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindAllOrderHistory: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/order.svc/history", null, successCallback, errorCallback); 

BWL.Services.Payment = 
  ListProvidersByCurrency: (currency, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/providers/{0}".format(currency)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindProviderInfoByType: (providerType, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/provider/{0}".format(providerType)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ListPaymentProviders: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/storeproviders/{0}".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
  BeginPayment: (storeKey, providerType, display, redirectURL, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/begin/{0}/{1}?display={2}&redirectURL={3}".format(storeKey, providerType, display, redirectURL)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  GetSessionState: (key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/state/{0}".format(key)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  CancelPayment: (key, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/payment.svc/cancel/{0}".format(key)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Root = 
  GetJavaScriptProxies: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/services.js", null, successCallback, errorCallback)
    
  GetJavaScriptProxiesMeta: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/servicesmeta.js", null, successCallback, errorCallback)
    
  GetJavaScriptModel: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/models.js", null, successCallback, errorCallback)
    
  GetJavaScriptModelMeta: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/modelsmeta.js", null, successCallback, errorCallback)
    
  GetJavaScriptModelEnum: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/modelsenum.js", null, successCallback, errorCallback)
    
  GetJavaScriptModelEmber: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/modelember.js", null, successCallback, errorCallback)
    
  GetServerVersion: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/version", null, successCallback, errorCallback)
    
  Initialize: (objInitializePayload, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/root.svc/initialize".format(objInitializePayload)
    BWL.InvokeService("POST", uri, objInitializePayload, successCallback, errorCallback)
    
  InitializeInfo: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/initializeinfo", null, successCallback, errorCallback)
    
  InitializeGEO: (successCallback, errorCallback) ->
    BWL.InvokeService("GET", "#{BWL.API_URL}/root.svc/initializegeo", null, successCallback, errorCallback); 

BWL.Services.Scanner = 
  ListDevices: (storeKey, levels, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/{1}".format(storeKey, levels)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  RegisterDevice: (storeKey, deviceKey, objDeviceInfo, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/register/{1}".format(storeKey, deviceKey, objDeviceInfo)
    BWL.InvokeService("PUT", uri, objDeviceInfo, successCallback, errorCallback)
    
  GetConfig: (storeKey, deviceKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/config/{1}".format(storeKey, deviceKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ListEventInfo: (storeKey, deviceKey, uniqueId, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/events/{1}/{2}".format(storeKey, deviceKey, uniqueId)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SyncGetTickets: (storeKey, deviceKey, eventKey, uniqueId, hash, sinceDateTime, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/sync/{1}/{2}/{3}?hash={4}&sinceDateTime={5}".format(storeKey, deviceKey, eventKey, uniqueId, hash, sinceDateTime)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SyncUpdateTickets: (storeKey, deviceKey, eventKey, uniqueId, objTickets, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/sync/{1}/{2}/{3}".format(storeKey, deviceKey, eventKey, uniqueId, objTickets)
    BWL.InvokeService("PUT", uri, objTickets, successCallback, errorCallback)
    
  SyncInitialTickets: (storeKey, deviceKey, eventKey, uniqueId, hash, compression, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/scanner.svc/{0}/init/{1}/{2}/{3}?hash={4}&compression={5}".format(storeKey, deviceKey, eventKey, uniqueId, hash, compression)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.SearchIndex = 
  Search: (searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/search?q={0}&o={1}&p={2}".format(searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SearchTags: (searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/tags?q={0}&o={1}&p={2}".format(searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SearchType: (type, searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/search/{0}?q={1}&o={2}&p={3}".format(type, searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SearchStore: (storeKey, searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/{0}/search?q={1}&o={2}&p={3}".format(storeKey, searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SearchStoreTags: (storeKey, searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/{0}/tags?q={1}&o={2}&p={3}".format(storeKey, searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  SearchStoreType: (storeKey, type, searchString, orderBy, page, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/searchindex.svc/{0}/search/{1}?q={2}&o={3}&p={4}".format(storeKey, type, searchString, orderBy, page)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Store = 
  ListStores: (levels, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/store.svc/{0}".format(levels)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindStoreKeyFromCustomURI: (customURI, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/store.svc/storeurl/{0}".format(customURI)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindStoreKeyFromFacebookPageId: (facebookPageId, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/store.svc/storeurl/facebookpage/{0}".format(facebookPageId)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindCustomURIInfoFromFullURL: (fullURL, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/store.svc/customuriinfo?fullurl={0}".format(fullURL)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  FindCustomURIInfoFromURI: (storeKey, URI, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/store.svc/customURI/{0}?URI={1}".format(storeKey, URI)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.StoreAdmin = 
  GetTicketTemplateList: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/storeadmin.svc/{0}/tickettemplatelist".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  GetSystemFontList: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/storeadmin.svc/{0}/systemfontlist".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  GetPreviewTicket: (storeKey, ticketItemType, ticketItemKey, backgroundColorHex, fontColorHex, fontType, template, customImageKey, includeDetails, includeTerms, includeTicketImage, includeTicketName, horizontal, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/storeadmin.svc/{0}/PreviewTicket/{1}/{2}?backgroundColorHex={3}&fontColorHex={4}&fontType={5}&template={6}&customImageKey={7}&includeDetails={8}&includeTerms={9}&includeTicketImage={10}&includeTicketName={11}&horizontal={12}".format(storeKey, ticketItemType, ticketItemKey, backgroundColorHex, fontColorHex, fontType, template, customImageKey, includeDetails, includeTerms, includeTicketImage, includeTicketName, horizontal)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback); 

BWL.Services.Upload = 
  UploadImage: (storeKey, uploadStream, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/upload.svc/{0}/image".format(storeKey, uploadStream)
    BWL.InvokeService("POST", uri, uploadStream, successCallback, errorCallback)
    
  UploadFile: (storeKey, uploadStream, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/upload.svc/{0}/file".format(storeKey, uploadStream)
    BWL.InvokeService("POST", uri, uploadStream, successCallback, errorCallback); 

BWL.Services.Wishlist = 
  GetWishlist: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/wishlist.svc/{0}".format(storeKey)
    BWL.InvokeService("GET", uri, null, successCallback, errorCallback)
    
  ClearWishlist: (storeKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/wishlist.svc/{0}".format(storeKey)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)
    
  AddWishlistItem: (storeKey, itemTypeName, itemKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/wishlist.svc/{0}/{1}/{2}".format(storeKey, itemTypeName, itemKey)
    BWL.InvokeService("PUT", uri, null, successCallback, errorCallback)
    
  RemoveWishlistItem: (storeKey, itemTypeName, itemKey, successCallback, errorCallback) ->
    uri = "#{BWL.API_URL}/wishlist.svc/{0}/{1}/{2}".format(storeKey, itemTypeName, itemKey)
    BWL.InvokeService("DELETE", uri, null, successCallback, errorCallback)