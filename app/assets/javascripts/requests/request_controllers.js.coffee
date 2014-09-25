RequestControllers = angular.module("RequestControllers", [
  "ngResource"
])

class RequestsCtrl

  constructor: (@scope, @http, @resource, @location, @Request, @routeParams, @root) ->
   # @location.path("/requests/7")
    that = this
    @root.location = @location
    # scope variable initializations
    @markerText = ""
    @titleText = "Select an existing Picnic from the map or make a\n\u2193"
    @markerPlace = false
    @scope.showRequest = false
    @requestsShow = false
    @newMarker = null
    @markers = []
    @currentRequest = null

    # set up request resources asynchronously
    @Request = @resource "/requests/:id.json"

    # set styles and default location for map
    @mapOptionsDefault = {
      styles: [
        { "featureType": "landscape", "stylers": [ { "hue": "#F1FF00" }, { "saturation": -27.4}, {"lightness": 9.4}, {"gamma": 1}] },
        {"featureType": "road.highway", "stylers": [ {"hue": "#0099FF"}, { "saturation": -20}, {"lightness": 36.4}, {"gamma": 1}] },
        {"featureType": "road.arterial", "stylers": [{"hue": "#00FF4F"}, { "saturation": 0}, {"lightness": 0}, {"gamma": 1}] },
        {"featureType": "road.local", "stylers": [ {"hue": "#FFB300"}, {"saturation": -38}, {"lightness": 11.2}, {"gamma": 1}] },
        {"featureType": "water", "stylers": [ {"hue": "#00B6FF"}, {"saturation": 4.2}, {"lightness": -63.4}, {"gamma": 1}] },
        {"featureType": "poi", "stylers": [{"hue": "#9FFF00"}, {"saturation": 0}, {"lightness": 0}, {"gamma": 1}] }
      ],

      center: {lat: 37.7577, lng: -122.4376},
      zoom: 12
    }

    this.initMap(@mapOptionsDefault)
    # @map = new google.maps.Map(document.getElementById("map-canvas"), @mapOptions)

    @input = document.getElementById('searchTextField');

    # google places search and autocomplete
    options = {
       types: ['geocode']
    }

    @searchBox = new google.maps.places.SearchBox @input, {}
    @autocomplete = new google.maps.places.Autocomplete @input, options

    google.maps.event.addListener @autocomplete, 'place_changed', =>
      console.log "Place changed"
      address = @autocomplete.getPlace()
      that.codeAddress(address.formatted_address)

    # geocoding
    @geocoder = new google.maps.Geocoder();

    this.initMarkers()

    # set up watcher for location changes
    @scope.$on '$locationChangeSuccess', (event) =>
      console.log @location
      # console.log @routeParams
      setTimeout =>
        this.initMarkers()
      , 300

  initMarkers: ->
    if @routeParams.id
      this.initShow()
    else
      this.populateMarkers()

  initMap: (options) ->
    @map = new google.maps.Map(document.getElementById("map-canvas"), options)

  populateMarkers: ->
    # populate map with markers
    that = this
    @Request.query (data) ->
      data.forEach (req) ->
        marker = that.addRequestMarker(req)
        google.maps.event.addListener marker, 'click', ->
          that.showRequest(that, marker.requestId)

  clearMarkers: ->
    @markers.forEach (marker) ->
      marker.setMap null
    @markers = []

  showRequest: (that, requestId) ->
    window.loc = @location
    @location.path("/requests/"+ requestId)
    @scope.$apply () ->

  initShow: ->
    console.log "Got here!"
    requestId = @routeParams.id
    this.clearMarkers()
    @Request.get {id: requestId}, (data) =>
      @currentRequest = data
      latLng = this.newLatLng(data.latitude, data.longitude)
      this.initMap({})
      @map.setCenter {lat: data.latitude, lng: data.longitude} 
      @map.setZoom(15)
      @map.setBounds
      @addRequestMarker(data)

  newLatLng: (lat, lng) ->
    latLng = new google.maps.LatLng(lat, lng)

  addRequestMarker: (req) ->

    latLng = this.newLatLng(req.latitude, req.longitude)
    # latLng = new google.maps.LatLng(req.latitude, req.longitude);
    
    marker = new google.maps.Marker {
      map: @map
      draggable: false
      animation: google.maps.Animation.DROP
    }
    
    marker.setPosition(latLng)
    marker.requestId = req.id
    @markers.push marker
    marker

  codeAddress: (address) ->
    @geocoder.geocode {"address": address}, (results, status) =>
      if status == google.maps.GeocoderStatus.OK
        @map.setCenter results[0].geometry.location
        @map.fitBounds results[0].geometry.viewport

      else
        alert "Geocode was not successful for the following reason:" + status

  createRequest: (newRequest) ->

    if @newMarker != null

      marker = @newMarker

      that = this

      # set the lat and long of the request from the marker position
      newRequest.latitude = @newMarker.position.k
      newRequest.longitude= @newMarker.position.B

      # create new request and send it to the server
      @Request.save newRequest, (data) =>
        marker.requestId = data.id
        @markers.push marker
        marker.place = false
        @scope.showRequest = false
        @requests.push data

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

    # clear current marker
    if @newMarker != null
      @newMarker.setMap null
      @newMarker = null

    # show and hide buttons
    @markerPlace = false
    @scope.showRequest = false

    # clear click event listeners from map
    google.maps.event.clearListeners @map, "click"




RequestControllers.controller("RequestsCtrl", 
  ["$scope", 
  "$http",
  "$resource", 
  "$location", 
  "Request", 
  "$routeParams", 
  "$rootScope", 
  RequestsCtrl])


