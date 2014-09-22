class Router

  constructor: (@routeProvider, @locationProvider) ->

    @routeProvider.
      when "/",
        templateUrl: "/site_templates",
        controller: "SitesCtrl as sites"
    
    # @routeProvider.
    #   when "/sessions",
    #     templateUrl: "site_templates",
    #     controller: "SitesCtrl as sites"

    @locationProvider.html5Mode(true)

SiteRouter = angular.module("SiteRouter", [
  "ngRoute"
])

SiteRouter.config(["$routeProvider", "$locationProvider", Router])

SiteRouter.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]