@prepTickets.directive('qrcode', [() ->
  restrict: 'E' 
  replace: true
  scope: 
    ticket: "="
  template: ' <div class="qrcode">
                <img ng-src="{{qrcodeUrl()}}" alt="QR Code for {{ticket.EventName}}">
              </div>'
  link: (scope) ->
    scope.qrcodeUrl = ->
      return "" unless scope.ticket?.DownloadLink
      scope.ticket.DownloadLink.replace("/ticket/", "/qrcode/")
])