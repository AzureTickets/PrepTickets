# DateTime formatter
@prepTickets.filter('datetime', [ () ->
    # 
    # @param {string} dateTimeString DateTime string to format
    # @returns {string} Formatted DateTime
    (dateTimeString, format="long") -> 
      
      switch format
        when "long" then format = "dddd, MMMM Do YYYY, h:mm a"
        when "short" then format = "MMMM D YYYY, h:mm a"
        when "day" then format = "DD"
        when "month3" then format = "MMM"
        when "year" then format = "YYYY"
      moment.utc(dateTimeString).format(format)
])