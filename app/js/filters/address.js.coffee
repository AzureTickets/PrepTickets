#
#Address normalization filter
#
@prepTickets.filter('address', () ->
  (addressObj) ->
    return "" unless addressObj?
    a = [addressObj.AddressLine1, addressObj.AddressLine2, addressObj.City, addressObj.PostalCode]
    a.filter(Boolean).join(', ')
)