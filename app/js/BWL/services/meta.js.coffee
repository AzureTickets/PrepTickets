throw "Can't use BWL.Services Meta without BWL and BWL.services module loaded" unless BWL? && BWL.Services?

# BWL.Services.SearchIndexService
BWL.Services.SearchIndex?.Search?.Meta = 
    __perms: 0
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

BWL.Services.SearchIndex?.SearchTags?.Meta = 
    __perms: 0
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

BWL.Services.SearchIndex?.SearchType?.Meta = 
    __perms: 0
    type: 'String'
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

BWL.Services.SearchIndex?.SearchStore?.Meta = 
    __perms: 0
    storeKey: 'String'
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

BWL.Services.SearchIndex?.SearchStoreTags?.Meta = 
    __perms: 0
    storeKey: 'String'
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

BWL.Services.SearchIndex?.SearchStoreType?.Meta = 
    __perms: 0
    storeKey: 'String'
    type: 'String'
    searchString: 'String'
    orderBy: 'String'
    page: 'String'

# BWL.Services.WishlistService
BWL.Services.Wishlist?.GetWishlist?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Wishlist?.ClearWishlist?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Wishlist?.AddWishlistItem?.Meta = 
    __perms: 10
    storeKey: 'String'
    itemTypeName: 'String'
    itemKey: 'String'

BWL.Services.Wishlist?.RemoveWishlistItem?.Meta = 
    __perms: 10
    storeKey: 'String'
    itemTypeName: 'String'
    itemKey: 'String'


# BWL.Services.DownloadService
BWL.Services.Download?.DownloadFile?.Meta = 
    __perms: 20
    storeKey: 'String'
    itemType: 'String'
    itemKey: 'String'

BWL.Services.Download?.DownloadTicket?.Meta = 
    __perms: 10
    storeKey: 'String'
    inventoryType: 'String'
    inventoryKey: 'String'

BWL.Services.Download?.DownloadTickets?.Meta = 
    __perms: 10
    storeKey: 'String'
    inventoryType: 'String'
    inventoryKeys: 'String'

BWL.Services.Download?.DownloadQRCode?.Meta = 
    __perms: 10
    storeKey: 'String'
    inventoryType: 'String'
    inventoryKey: 'String'


# BWL.Services.MessageService
BWL.Services.Message?.GetMessagesProviders?.Meta = 
    __perms: 10

BWL.Services.Message?.SendMessage?.Meta = 
    __perms: 10
    storeKey: 'String'
    messagesProvider: 'String'
    objMessage: 'Stream'

BWL.Services.Message?.SendStoreAdminMessage?.Meta = 
    __perms: 10
    storeKey: 'String'
    objMessage: 'Stream'

BWL.Services.Message?.SendAdminMessage?.Meta = 
    __perms: 10
    storeKey: 'String'
    objMessage: 'Stream'


# BWL.Services.OrderService
BWL.Services.Order?.ProcessOrder?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Order?.SetOrderState?.Meta = 
    __perms: 20
    storeKey: 'String'
    orderKey: 'String'
    orderState: 'String'

BWL.Services.Order?.FindOrders?.Meta = 
    __perms: 20
    storeKey: 'String'
    orderState: 'String'
    startDate: 'String'
    endDate: 'String'

BWL.Services.Order?.FindOrderHistory?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Order?.FindAllOrderHistory?.Meta = 
    __perms: 10


# BWL.Services.PaymentService
BWL.Services.Payment?.ListProvidersByCurrency?.Meta = 
    __perms: 10
    currency: 'String'

BWL.Services.Payment?.FindProviderInfoByType?.Meta = 
    __perms: 10
    providerType: 'String'

BWL.Services.Payment?.ListPaymentProviders?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Payment?.BeginPayment?.Meta = 
    __perms: 10
    storeKey: 'String'
    providerType: 'String'
    display: 'String'
    redirectURL: 'String'

BWL.Services.Payment?.GetSessionState?.Meta = 
    __perms: 10
    key: 'String'

BWL.Services.Payment?.CancelPayment?.Meta = 
    __perms: 10
    key: 'String'


# BWL.Services.ModelService
BWL.Services.Model?.Create?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    obj: 'Stream'

BWL.Services.Model?.Read?.Meta = 
    __perms: 0
    storeKey: 'String'
    type: 'String'
    key: 'String'
    levels: 'String'

BWL.Services.Model?.Update?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    key: 'String'
    obj: 'Stream'

BWL.Services.Model?.Delete?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    key: 'String'

BWL.Services.Model?.Add?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    key: 'String'
    property: 'String'
    addType: 'String'
    addObject: 'Stream'

BWL.Services.Model?.Get?.Meta = 
    __perms: 0
    storeKey: 'String'
    type: 'String'
    key: 'String'
    property: 'String'
    levels: 'String'

BWL.Services.Model?.Remove?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    key: 'String'
    property: 'String'
    removeType: 'String'
    removeKey: 'String'

BWL.Services.Model?.List?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    page: 'String'

BWL.Services.Model?.Find?.Meta = 
    __perms: 10
    storeKey: 'String'
    type: 'String'
    page: 'String'
    obj: 'Stream'

BWL.Services.Model?.ImportFromPOST?.Meta = 
    __perms: 100
    storeKey: 'String'
    type: 'String'
    obj: 'Stream'

BWL.Services.Model?.ImportFromURL?.Meta = 
    __perms: 100
    storeKey: 'String'
    type: 'String'
    url: 'String'


# BWL.Services.MediaLibraryService
BWL.Services.MediaLibrary?.CropResizeImage?.Meta = 
    __perms: 20
    storeKey: 'String'
    key: 'String'
    objImageCropResize: 'Stream'

BWL.Services.MediaLibrary?.ListImages?.Meta = 
    __perms: 20
    storeKey: 'String'

BWL.Services.MediaLibrary?.DeleteImage?.Meta = 
    __perms: 20
    storeKey: 'String'
    key: 'String'

BWL.Services.MediaLibrary?.ListFiles?.Meta = 
    __perms: 20
    storeKey: 'String'

BWL.Services.MediaLibrary?.DeleteFile?.Meta = 
    __perms: 20
    storeKey: 'String'
    key: 'String'


# BWL.Services.AuthService
BWL.Services.Auth?.ListAuthProviders?.Meta = 
    __perms: 0

BWL.Services.Auth?.BeginAuth?.Meta = 
    __perms: 0
    providerName: 'String'
    clientKey: 'String'
    display: 'String'
    redirectURL: 'String'

BWL.Services.Auth?.GetSessionState?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Auth?.GetTokenState?.Meta = 
    __perms: 10

BWL.Services.Auth?.GetToken?.Meta = 
    __perms: 0
    sessionKey: 'String'
    clientKey: 'String'
    clientSecret: 'String'

BWL.Services.Auth?.CancelAuth?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Auth?.Logon?.Meta = 
    __perms: 0
    providerName: 'String'
    clientKey: 'String'
    display: 'String'
    redirectURL: 'String'

BWL.Services.Auth?.Logoff?.Meta = 
    __perms: 10

BWL.Services.Auth?.AddLogon?.Meta = 
    __perms: 10
    providerName: 'String'
    clientKey: 'String'
    display: 'String'
    redirectURL: 'String'

BWL.Services.Auth?.RemoveLogon?.Meta = 
    __perms: 10
    AuthProfileKey: 'String'


# BWL.Services.ScannerService
BWL.Services.Scanner?.ListDevices?.Meta = 
    __perms: 20
    storeKey: 'String'
    levels: 'String'

BWL.Services.Scanner?.RegisterDevice?.Meta = 
    __perms: 0
    storeKey: 'String'
    deviceKey: 'String'
    objDeviceInfo: 'Stream'

BWL.Services.Scanner?.GetConfig?.Meta = 
    __perms: 20
    storeKey: 'String'
    deviceKey: 'String'

BWL.Services.Scanner?.ListEventInfo?.Meta = 
    __perms: 0
    storeKey: 'String'
    deviceKey: 'String'
    uniqueId: 'String'

BWL.Services.Scanner?.SyncGetTickets?.Meta = 
    __perms: 0
    storeKey: 'String'
    deviceKey: 'String'
    eventKey: 'String'
    uniqueId: 'String'
    hash: 'String'
    sinceDateTime: 'String'

BWL.Services.Scanner?.SyncUpdateTickets?.Meta = 
    __perms: 0
    storeKey: 'String'
    deviceKey: 'String'
    eventKey: 'String'
    uniqueId: 'String'
    objTickets: 'Stream'

BWL.Services.Scanner?.SyncInitialTickets?.Meta = 
    __perms: 0
    storeKey: 'String'
    deviceKey: 'String'
    eventKey: 'String'
    uniqueId: 'String'
    hash: 'String'
    compression: 'String'


# BWL.Services.AccountService
BWL.Services.Account?.GetProfile?.Meta = 
    __perms: 0

BWL.Services.Account?.Register?.Meta = 
    __perms: 0
    requestedRole: 'String'
    objAccount: 'Stream'

BWL.Services.Account?.Logon?.Meta = 
    __perms: 0
    objAccount: 'Stream'

BWL.Services.Account?.Logoff?.Meta = 
    __perms: 10

BWL.Services.Account?.Signup?.Meta = 
    __perms: 10

BWL.Services.Account?.ChangePassword?.Meta = 
    __perms: 10
    newPasswordHash: 'String'
    objAccount: 'Stream'

BWL.Services.Account?.ResetPassword?.Meta = 
    __perms: 0
    objAccount: 'Stream'

BWL.Services.Account?.AccessRequest?.Meta = 
    __perms: 10
    type: 'String'
    key: 'String'
    requestedAccess: 'String'

BWL.Services.Account?.AccessRequestFor?.Meta = 
    __perms: 100
    type: 'String'
    key: 'String'
    profileKey: 'String'
    requestedAccess: 'String'

BWL.Services.Account?.AccessAdd?.Meta = 
    __perms: 10
    type: 'String'
    key: 'String'
    profileKey: 'String'
    access: 'String'

BWL.Services.Account?.AccessPending?.Meta = 
    __perms: 10

BWL.Services.Account?.AccessApprove?.Meta = 
    __perms: 10
    key: 'String'

BWL.Services.Account?.AccessReject?.Meta = 
    __perms: 10
    key: 'String'


# BWL.Services.CartService
BWL.Services.Cart?.AddItems?.Meta = 
    __perms: 10
    storeKey: 'String'
    itemTypeName: 'String'
    itemKey: 'String'
    quantity: 'String'
    options: 'Stream'

BWL.Services.Cart?.AddAddress?.Meta = 
    __perms: 10
    storeKey: 'String'
    addressKey: 'String'

BWL.Services.Cart?.RemoveItems?.Meta = 
    __perms: 10
    storeKey: 'String'
    itemTypeName: 'String'
    itemKey: 'String'
    quantity: 'String'

BWL.Services.Cart?.GetCart?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Cart?.HasCart?.Meta = 
    __perms: 10
    storeKey: 'String'

BWL.Services.Cart?.ClearCart?.Meta = 
    __perms: 10
    storeKey: 'String'


# BWL.Services.GeoService
BWL.Services.Geo?.ReadContinent?.Meta = 
    __perms: 0
    continentKey: 'String'

BWL.Services.Geo?.ListContinents?.Meta = 
    __perms: 0

BWL.Services.Geo?.ReadCountry?.Meta = 
    __perms: 0
    countryKey: 'String'

BWL.Services.Geo?.FindCountryByISO?.Meta = 
    __perms: 0
    countryISO: 'String'

BWL.Services.Geo?.ListCountries?.Meta = 
    __perms: 0

BWL.Services.Geo?.ListCountriesByContinent?.Meta = 
    __perms: 0
    continentISO: 'String'

BWL.Services.Geo?.ReadCurrency?.Meta = 
    __perms: 0
    currencyKey: 'String'

BWL.Services.Geo?.ListCurrencies?.Meta = 
    __perms: 0

BWL.Services.Geo?.ReadRegion?.Meta = 
    __perms: 0
    regionKey: 'String'

BWL.Services.Geo?.FindRegionByISO?.Meta = 
    __perms: 0
    countryISO: 'String'
    regionISO: 'String'

BWL.Services.Geo?.ListRegionsByCountry?.Meta = 
    __perms: 0
    countryISO: 'String'

BWL.Services.Geo?.ReadCity?.Meta = 
    __perms: 0
    cityKey: 'String'

BWL.Services.Geo?.ListCitiesByRegion?.Meta = 
    __perms: 0
    countryISO: 'String'
    regionISO: 'String'

BWL.Services.Geo?.FindCity?.Meta = 
    __perms: 0
    name: 'String'
    countryISO: 'String'
    regionISO: 'String'

BWL.Services.Geo?.FindCities?.Meta = 
    __perms: 0
    name: 'String'
    countryISO: 'String'
    regionISO: 'String'

BWL.Services.Geo?.ReadPostal?.Meta = 
    __perms: 0
    postalKey: 'String'

BWL.Services.Geo?.FindPostalCode?.Meta = 
    __perms: 0
    countryISO: 'String'
    code: 'String'

BWL.Services.Geo?.ReadTimezone?.Meta = 
    __perms: 0
    timezoneKey: 'String'

BWL.Services.Geo?.ListTimezones?.Meta = 
    __perms: 0

BWL.Services.Geo?.ListTimezonesByCountryISO?.Meta = 
    __perms: 0
    countryISO: 'String'


# BWL.Services.StoreAdminService
BWL.Services.StoreAdmin?.GetTicketTemplateList?.Meta = 
    __perms: 20
    storeKey: 'String'

BWL.Services.StoreAdmin?.GetSystemFontList?.Meta = 
    __perms: 20
    storeKey: 'String'

BWL.Services.StoreAdmin?.GetPreviewTicket?.Meta = 
    __perms: 20
    storeKey: 'String'
    ticketItemType: 'String'
    ticketItemKey: 'String'
    backgroundColorHex: 'String'
    fontColorHex: 'String'
    fontType: 'String'
    template: 'String'
    customImageKey: 'String'
    includeDetails: 'String'
    includeTerms: 'String'
    includeTicketImage: 'String'
    includeTicketName: 'String'
    horizontal: 'String'


# BWL.Services.InventoryService
BWL.Services.Inventory?.AddInventoryItems?.Meta = 
    __perms: 20
    storeKey: 'String'
    type: 'String'
    key: 'String'
    quantity: 'String'

BWL.Services.Inventory?.RemoveInventoryItems?.Meta = 
    __perms: 20
    storeKey: 'String'
    type: 'String'
    key: 'String'
    quantity: 'String'

BWL.Services.Inventory?.GetInventoryStats?.Meta = 
    __perms: 0
    storeKey: 'String'
    type: 'String'
    key: 'String'


# BWL.Services.StoreService
BWL.Services.Store?.ListStores?.Meta = 
    __perms: 20
    levels: 'String'

BWL.Services.Store?.FindStoreKeyFromCustomURI?.Meta = 
    __perms: 0
    customURI: 'String'

BWL.Services.Store?.FindStoreKeyFromFacebookPageId?.Meta = 
    __perms: 0
    facebookPageId: 'String'

BWL.Services.Store?.FindCustomURIInfoFromFullURL?.Meta = 
    __perms: 0
    fullURL: 'String'

BWL.Services.Store?.FindCustomURIInfoFromURI?.Meta = 
    __perms: 0
    storeKey: 'String'
    URI: 'String'


# BWL.Services.RootService
BWL.Services.Root?.GetJavaScriptProxies?.Meta = 
    __perms: 0

BWL.Services.Root?.GetJavaScriptProxiesMeta?.Meta = 
    __perms: 0

BWL.Services.Root?.GetJavaScriptModel?.Meta = 
    __perms: 0

BWL.Services.Root?.GetJavaScriptModelMeta?.Meta = 
    __perms: 0

BWL.Services.Root?.GetJavaScriptModelEnum?.Meta = 
    __perms: 0

BWL.Services.Root?.GetJavaScriptModelEmber?.Meta = 
    __perms: 0

BWL.Services.Root?.GetServerVersion?.Meta = 
    __perms: 0

BWL.Services.Root?.Initialize?.Meta = 
    __perms: 0
    objInitializePayload: 'Stream'

BWL.Services.Root?.InitializeInfo?.Meta = 
    __perms: 0

BWL.Services.Root?.InitializeGEO?.Meta = 
    __perms: 0


# BWL.Services.UploadService
BWL.Services.Upload?.UploadImage?.Meta = 
    __perms: 20
    storeKey: 'String'
    uploadStream: 'Stream'

BWL.Services.Upload?.UploadFile?.Meta = 
    __perms: 20
    storeKey: 'String'
    uploadStream: 'Stream'


# BWL.Services.AccountsService
BWL.Services.Accounts?.Root?.Meta = 
    __perms: 0

BWL.Services.Accounts?.GetProfile?.Meta = 
    __perms: 10

BWL.Services.Accounts?.Register?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Accounts?.VerifyEmail?.Meta = 
    __perms: 0
    email: 'String'
    approveToken: 'String'

BWL.Services.Accounts?.ApproveRegister?.Meta = 
    __perms: 0
    email: 'String'
    approveToken: 'String'

BWL.Services.Accounts?.Logon?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Accounts?.Logoff?.Meta = 
    __perms: 10

BWL.Services.Accounts?.Signup?.Meta = 
    __perms: 10
    sessionKey: 'String'

BWL.Services.Accounts?.ChangePassword?.Meta = 
    __perms: 10
    sessionKey: 'String'

BWL.Services.Accounts?.ResetPassword?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Accounts?.ApproveResetPassword?.Meta = 
    __perms: 0
    email: 'String'
    approveToken: 'String'

BWL.Services.Accounts?.Authorize?.Meta = 
    __perms: 0
    sessionKey: 'String'

BWL.Services.Accounts?.AuthorizeApprove?.Meta = 
    __perms: 10
    sessionKey: 'String'

BWL.Services.Accounts?.AuthorizeCancel?.Meta = 
    __perms: 10
    sessionKey: 'String'

