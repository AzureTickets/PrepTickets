@prepTickets.directive('qrcode', ["ProfileService", (ProfileService) ->
  restrict: 'E' 
  replace: true
  scope:
    ticket: "="
  template: ' <div class="qrcode">
                <img ng-src="{{qrcodeUrl()}}" alt="QR Code for {{ticket.EventName}}" class="img-responsive">
              </div>'
  link: (scope) ->
    scope.qrcodeUrl = ->
      return "" unless scope.ticket?.DownloadLink
      url = scope.ticket.DownloadLink.replace("/ticket/", "/qrcode/")
      url += "?token=#{token}" if token = ProfileService.accessToken()
      url
])