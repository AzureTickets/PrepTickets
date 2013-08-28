@prepTickets.directive('map', ["$http", "$window", "configService", ($http, $window,  ConfigService) ->
  buildURLFromObject = (object) ->
    return "" unless object
    objectString = ""
    for key,value of object
      objectString += "&" unless objectString is ""
      objectString += "#{key}=#{encodeURIComponent(value)}" unless value is ""

    objectString

  restrict: 'E' 
  replace: true
  scope: 
    places: "=" 
  template: '<div id="mapDiv" style="position:absolute;width:100%;height:280px;"></div>'
  link: (scope, element, attrs) ->
    scope.$watch("places", (newValue, oldValue) ->
      if Microsoft?.Maps and newValue?
        scope.map = new Microsoft.Maps.Map(
          element[0]
          credentials:ConfigService.BingMapKey
          mapTypeId: Microsoft.Maps.MapTypeId.road
          zoom: 14
          enableSearchLogo: false
          showScalebar: false
          disableMouseInput: false
          disableZooming: true
          showMapTypeSelector: false
        ) unless scope.map
        
        angular.forEach scope.places, (place) ->
          if place.Address?
            if place.Address.Latitude is 0 and place.Address.Longitude is 0 #If we don't know where it is
              mapAttr = 
                countryRegion: place.Address.Country || ""
                adminDistrict: place.Address.Region || ""
                locality: ""
                postalCode: place.Address.PostalCode || ""
                addressLine: place.Address.AddressLine1 || ""
                maxResults: "1"
                key: ConfigService.BingMapKey
                output: "json"

              
              url = "http://dev.virtualearth.net/REST/v1/Locations?#{buildURLFromObject(mapAttr)}&jsonp=map_callback"
              # console.log mapAttr, mapAttrString, url

              $window.map_callback = (data) =>
                if data.statusCode is 200
                  coor = data.resourceSets[0].resources?[0].geocodePoints?[0].coordinates
                  if coor
                    ll = new Microsoft.Maps.Location(coor[0], coor[1])
                    map_target.map.entities.push(new Microsoft.Maps.Pushpin(ll, {}));
                    map_target.map.setView({center: ll, zoom: 15})
              $window.map_target = scope

              $http.jsonp(url)
            else
              ll = new Microsoft.Maps.Location(place.Address.Latitude, place.Address.Longitude)
              scope.map.entities.push(new Microsoft.Maps.Pushpin(ll, {}));
    )
])