RequestControllers = angular.module("RequestControllers", [
  "ngResource"
])

class RequestsCtrl

  contsructor: (@scope, @http, @resource) ->
    console.log arguments
    this.greeting = "Hello World"
    @Request = @resource("/requests/:id.json")
    @Request.query (data) =>
      @requests = data

RequestControllers.controller("RequestsCtrl", ["$scope", "$http", "$resource", RequestsCtrl])


