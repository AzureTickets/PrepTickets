# DateTime formatter
@prepTickets.filter('datetime', [ () ->
    # 
    # @param {string} dateTimeString DateTime string to format
    # @returns {string} Formatted DateTime
    (dateTimeString, format="long") -> 
      
      switch format
        when "long" then format = "dddd, MMMM Do YYYY, h:mm:ss a"
        when "short" then format = "MMM D YYYY, h:mm:ss a"
      moment.utc(dateTimeString).format(format)
])