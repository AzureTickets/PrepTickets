TicketService = @prepTickets.factory('TicketService', () ->
  getTickets: (event) ->
    return unless event?.Items
    tickets = []
    for ticket in event.Items
      console.log ticket
      tickets.push(ticket)
      tickets.push(tieredTicket) for tieredTicket in ticket.PricingTiers if ticket.PricingTiers
    tickets
)
TicketService.$inject = []