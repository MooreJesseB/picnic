class Router

  constructor: (@routeProvider, @locationProvider) ->

    @routeProvider.
      when "/users/:id",
        templateUrl: "/user_templates",
        controller: "UsersCtrl as users"
    
    @locationProvider.html5Mode(true)

UserRouter = angular.module("UserRouter", [
  "ngRoute"
])

UserRouter.config(["$routeProvider", "$locationProvider", Router])

UserRouter.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]