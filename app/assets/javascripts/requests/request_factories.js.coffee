RequestFactories = angular.module("RequestFactories", [])

class Request 

  constructor: (@http) ->

    all: () ->
      @http.get("/requests.json")

    create: (newRequest) ->
      @http.post("/requests.json", {request: newRequest})

RequestFactories.service("Request", ["$http", Request])