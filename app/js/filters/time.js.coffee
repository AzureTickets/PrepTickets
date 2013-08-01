# Time formatter
@prepTickets.filter('time', [ () ->
    # 
    # @param {string} timeString Date string to format
    # @returns {string} Formatted Time
    (timeString, format="long") -> 
      
      switch format
        when "long" then format = "h:mm:ss a"
        when "short" then format = "h:mm a"
      moment.utc(timeString).format(format)
])