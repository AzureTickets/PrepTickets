@BWL = 
  #Global variables

  # System vars
  API_URL: "http://stage.azuretickets.com"
  Server: null
  TokenName: 'token'
  ClientKey: null
  ElementMap: []
  URIDELIMITER: "#!/"
  RETRYDELAY: 500
  LastLocation: null

  # Store info
  Store: null
  StoreKey: null
  Currency: null

  # Profile
  Profile: null

  # Shopping Carts
  ClientCart: []
  ServerCart: []

  #Load i18n to make translation feature work correctly
  #This just prevents app from crashing if i18n isn't loaded
  t: (msg, options={}) ->
    console.warn "BWL.t doesn't work correctly till the i18n module is loaded" if console?
    msg

  InvokeService: (method, url, data, successCallback, errorCallback) ->
    BWL.Data.InvokeService(method, url, data, successCallback, errorCallback);