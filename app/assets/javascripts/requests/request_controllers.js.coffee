RequestControllers = angular.module("RequestControllers", [
  "ngResource"
])

class RequestsCtrl

  constructor: (@scope, @http, @resource, @Request) ->
    @markerText = ""
    @titleText = "Select an existing Picnic from the map or make a\n\u2193"
    @markerPlace = false
    # @showRequest = false
    @scope.showRequest = false
    @newMarker = null

    # set styles and default location for map
    @mapOptions = {
      styles: [
        { "featureType": "landscape", "stylers": [ { "hue": "#F1FF00" }, { "saturation": -27.4}, {"lightness": 9.4}, {"gamma": 1}] },
        {"featureType": "road.highway", "stylers": [ {"hue": "#0099FF"}, { "saturation": -20}, {"lightness": 36.4}, {"gamma": 1}] },
        {"featureType": "road.arterial", "stylers": [{"hue": "#00FF4F"}, { "saturation": 0}, {"lightness": 0}, {"gamma": 1}] },
        {"featureType": "road.local", "stylers": [ {"hue": "#FFB300"}, {"saturation": -38}, {"lightness": 11.2}, {"gamma": 1}] },
        {"featureType": "water", "stylers": [ {"hue": "#00B6FF"}, {"saturation": 4.2}, {"lightness": -63.4}, {"gamma": 1}] },
        {"featureType": "poi", "stylers": [{"hue": "#9FFF00"}, {"saturation": 0}, {"lightness": 0}, {"gamma": 1}] }
      ],

      center: { lat: 37.7577, lng: -122.4376},
      zoom: 12
    }
    @map = new google.maps.Map(document.getElementById("map-canvas"), @mapOptions)

    @input = document.getElementById('searchTextField');

    

    # google places search and autocomplete

    @options = {
       types: ['geocode']
    }

    @searchBox = new google.maps.places.SearchBox @input, {}
    @autocomplete = new google.maps.places.Autocomplete @input, @options

    that = this

    google.maps.event.addListener @autocomplete, 'place_changed', =>
      address = @autocomplete.getPlace()
      that.codeAddress(address.formatted_address)

    # geocoding
    @geocoder = new google.maps.Geocoder();

    # This prevents google places search form from submitting while autocomplete bubble is acive
    this.preventSubmit()

  preventSubmit: ->
    console.log "Got here!"
    toggle = false
    input = document.getElementById('searchTextField')
    google.maps.event.addDomListener input, 'keydown', (e) ->
      if e.keyCode == 13
        if e.preventDefault
          e.preventDefault()
          console.log "Prevent Default"
        else
          console.log "This sould work!"
          e.cancelBubble = true
          e.returnValue = false

  codeAddress: (address) ->
    console.log address
    console.log "got to code address"
    @geocoder.geocode {"address": address}, (results, status) =>
      if status == google.maps.GeocoderStatus.OK
        console.log results
        @map.setCenter results[0].geometry.location
        @map.fitBounds results[0].geometry.viewport

      else
        alert "Geocode was not successful for the following reason:" + status

  createRequest: (newRequest) ->

    if @newMarker != null

      # set the lat and long of the request from the marker position
      newRequest.latitude = @newMarker.position.k
      newRequest.longitude= @newMarker.position.B

      # create new request and send it to the server
      @Request.create newRequest, (data) ->
        console.log data
        @marker.place = false
        @scope.showRequest = false

    else

      @markerText = "You must place a marker to continue"

  markerPlaceMode: -> 
    
    @markerPlace = true

    @scope.showRequest = true

    @markerText = "\u2190   Please place a marker on the map"

    # add cilck event listener to google maps for placement of marker
    listenerHandle = google.maps.event.addListener @map, "click", (event) => 

      # clear any existant marker
      if @newMarker != null
        @newMarker.setMap(null)

      # mouseclick location on map
      markerPosition = event.latLng

      # create the new marker
      @newMarker = new google.maps.Marker {
        map: @map
        draggable: true
        animation: google.maps.Animation.DROP
      }

      # set location on new marker
      @newMarker.setPosition(markerPosition)


  cancelMarkerPlace: ->
    
    console.log @newMarker

    # clear current marker
    @newMarker.setMap null
    @newMarker = null

    # show and hide buttons
    @markerPlace = false
    @scope.showRequest = false

    # clear click event listeners from map
    google.maps.event.clearListeners @map, "click"




RequestControllers.controller("RequestsCtrl", ["$scope", "$http", "$resource", "Request", RequestsCtrl])


