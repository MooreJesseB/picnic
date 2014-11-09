RequestControllers = angular.module("RequestControllers", [
  "ngResource"
])

class RequestsCtrl

  constructor: (@scope, @http, @resource, @location, @Request, @routeParams, @Photo, @root) ->
   # @location.path("/requests/7")
    that = this
    @root.location = @location
    # scope variable initializations
    @markerText = ""
    @titleText = "Select an existing Picniq from the map or make a\n\u2193"
    @markerPlace = false
    @scope.showRequest = false
    @requestsShow = false
    @submitPhoto = false
    @newMarker = null
    @currentRequest = null
    @markers = []
    @photos = []
    @newPhoto = {}
    @currentPhoto = {}
    @showPhotoNow = false

    # set up request resources
    @Request = @resource "/requests/:id.json"

    # set up photo resources
    @Photo = @resource "/photos/:id.json"

    # set styles and default location for map
    @mapOptionsDefault = {

      # dark style
      styles: [
        {"featureType":"water","stylers":[{"color":"#021019"}]},
        {"featureType":"landscape","stylers":[{"color":"#08304b"}]},
        {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#0c4152"},{"lightness":5}]},
        {"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},
        {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#0b434f"},{"lightness":25}]},
        {"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},
        {"featureType":"road.arterial","elementType":"geometry.stroke","stylers":[{"color":"#0b3d51"},{"lightness":16}]},
        {"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"}]},
        {"elementType":"labels.text.fill","stylers":[{"color":"#ffffff"}]},
        {"elementType":"labels.text.stroke","stylers":[{"color":"#000000"},{"lightness":13}]},
        {"featureType":"transit","stylers":[{"color":"#146474"}]},
        {"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"}]},
        {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#144b53"},{"lightness":14},{"weight":1.4}]}
      ],
      
      # lighter blue style
      # styles: [
      #   { "featureType": "landscape", "stylers": [ { "hue": "#F1FF00" }, { "saturation": -27.4}, {"lightness": 9.4}, {"gamma": 1}] },
      #   {"featureType": "road.highway", "stylers": [ {"hue": "#0099FF"}, { "saturation": -20}, {"lightness": 36.4}, {"gamma": 1}] },
      #   {"featureType": "road.arterial", "stylers": [{"hue": "#00FF4F"}, { "saturation": 0}, {"lightness": 0}, {"gamma": 1}] },
      #   {"featureType": "road.local", "stylers": [ {"hue": "#FFB300"}, {"saturation": -38}, {"lightness": 11.2}, {"gamma": 1}] },
      #   {"featureType": "water", "stylers": [ {"hue": "#00B6FF"}, {"saturation": 4.2}, {"lightness": -63.4}, {"gamma": 1}] },
      #   {"featureType": "poi", "stylers": [{"hue": "#9FFF00"}, {"saturation": 0}, {"lightness": 0}, {"gamma": 1}] }
      # ],

      center: {lat: 37.7577, lng: -122.4376},
      zoom: 12
    }
  
    this.initMap(@mapOptionsDefault)

    # @map = new google.maps.Map(document.getElementById("map-canvas"), @mapOptions)

    # google places search and autocomplete
    @input = document.getElementById('searchTextField');

    options = {
       types: ['geocode']
    }

    @searchBox = new google.maps.places.SearchBox @input, {}
    @autocomplete = new google.maps.places.Autocomplete @input, options

    # this listens for google places autocomplete and submits it for geocoding without a submit form
    google.maps.event.addListener @autocomplete, 'place_changed', =>
      console.log "Place changed"
      address = @autocomplete.getPlace()
      that.codeAddress(address.formatted_address)

    # geocoder
    @geocoder = new google.maps.Geocoder();

    # initialize markers on the map - this will need to limit the search area..
    # otherwise it will get every single request and make a marker of of all of them

    this.initMarkers()

    @scope.$on '$locationChangeStart', (event) =>


    # set up watcher for location changes
    # @scope.$on '$locationChangeSuccess', (event) =>
    #   console.log @location
    #   # Super janky hack.  Apparently $locationChangeSuccess is called a while before $routeParams is updated
    #   setTimeout =>
    #     this.initMarkers()
    #   , 300

  initMarkers: ->
    this.clearMarkers()
    setTimeout =>

      if @routeParams.id
        # for showing an individual request
        this.initShow()
      else
        # for showing all requests
        this.populateMarkers()
    , 500

  initMap: (options) ->
    if !options
      options = @mapOptionsDefault
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

    @photos = []

    requestId = @routeParams.id

    @Request.get {id: requestId}, (data) =>
      @currentRequest = data

      # set up new map
      latLng = this.newLatLng(data.latitude, data.longitude)
      this.initMap()
      @map.setCenter {lat: data.latitude, lng: data.longitude} 
      @map.setZoom(17)
      @map.setBounds
      @addRequestMarker(data)

      #get photos for this request
      @Photo.query (data) =>
        @photos = data

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
        # @requests.push data
        @location.path("/requests/"+ data.id)
        # @scope.$apply () ->

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

  createPhotoFromUrl: (photo) ->
    id = @routeParams.id

    @Photo.save {id: id, photo}, (data) =>
      @photos.push photo
      @newPhoto = {}

    this.hidePhotoSubmit()

  createPhotoFromUpload: (photo) ->

  showPhotoSubmit: ->
    @submitPhoto = true
    

  hidePhotoSubmit: ->
    @submitPhoto = false

  showPhoto: (photo) ->
    @showPhotoNow = true
    @currentPhoto = photo

  hidePhoto: ->
    @showPhotoNow = false
    @currentPhoto = null


RequestControllers.controller("RequestsCtrl", 
  ["$scope", 
  "$http",
  "$resource", 
  "$location", 
  "Request", 
  "$routeParams", 
  "$rootScope", 
  "Photo",
  RequestsCtrl])


