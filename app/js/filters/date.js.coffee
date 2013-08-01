# Date formatter
@prepTickets.filter('date', [ () ->
    # 
    # @param {string} dateString Date string to format
    # @returns {string} Formatted Date
    (dateString, format="long") -> 
      
      switch format
        when "long" then format = "dddd, MMMM Do YYYY"
        when "short" then format = "MMM D YYYY"
      moment.utc(dateString).format(format)
])