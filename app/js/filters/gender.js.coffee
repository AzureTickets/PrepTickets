#
# Gender Translator
#
@prepTickets.filter('gender', () ->
  (genderID) ->
    return "" unless genderID?
    for key, value of BWL.Models.GenderEnum
      return key if value is genderID
    "Undisclosed"

)