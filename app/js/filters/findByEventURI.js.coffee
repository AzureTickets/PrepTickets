findByEventURI = @prepTickets.filter('findByEventURI', () ->
  (events, URI) -> 
    return unless events
    for event in events
      return event if event.CustomURI?.URI == URI 
    null
)

# findByEventURI.$inject = []