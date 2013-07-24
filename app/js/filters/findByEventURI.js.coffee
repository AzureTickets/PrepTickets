findByEventURI = @prepTickets.filter('findByEventURI', () ->
  (events, URI) -> 
    for event in events
      return event if event.CustomURI?.URI == URI 
    null
)

# findByEventURI.$inject = []