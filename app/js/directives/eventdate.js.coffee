@prepTickets.directive('eventdate', () ->
  restrict: 'E' 
  replace: true
  scope: 
    event: "="
    format: "@"
  template: '<div class="eventinfo dates" ng-show="event">
                <div class="sameday" ng-show="sameDay()">
                  <div class="eventdate">{{startTime().format("MMMM Do YYYY")}}</div>
                  <div class="eventtime">
                    <span class="starttime">{{startTime().format("h:mm A")}}</span> - <span class="endtime">{{endTime().format("h:mm A")}}</span>
                  </div>
                </div>
                <div class="differentday" ng-hide="sameDay()" style="display:none;">
                  <span class="eventdatetime">{{startTime().format("MMMM Do YYYY, h:mm A")}}</span>
                  till
                  <span class="eventdatetime">{{endTime().format("MMMM Do YYYY, h:mm A")}}</span>
                </div>
             </div>'
  link: (scope, element, attr) ->
    scope.startTime = ->
      moment.utc(scope.event?.StartTime)
    scope.endTime = ->
      moment.utc(scope.event?.EndTime)
    scope.sameDay = ->
      false #scope.endTime().diff(scope.startTime(), 'days') < 1

)