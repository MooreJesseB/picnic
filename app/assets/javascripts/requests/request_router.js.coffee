class Router

  constructor: (@routeProvider, @locationProvider) ->

    @routeProvider.
      when "/requests",
        templateUrl: "/request_templates",
        controller: "RequestsCtrl as requests"

    @locationProvider.html5Mode(true)

RequestRouter = angular.module("RequestRouter", [
  "ngRoute"
])

RequestRouter.config(["$routeProvider", "$locationProvider", Router])

RequestRouter.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]