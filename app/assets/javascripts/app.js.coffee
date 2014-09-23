PicnicApp = angular.module("PicnicApp", [
  "ngResource",
  "ngRoute",
  "templates"
  ])

PicnicApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->

  $routeProvider
    .when "/",
      templateUrl: "index.html",
      controller: "SitesCtrl"
  .otherwise redirectTo "/"

  $locationProvider.html5Mode(true)
]

PicnicApp.controller "SitesCtrl", ["$scope", "$http", "$resource", "$location", ($scope, $http, $resource, $location) ->

  $scope.login = false
  $scope.signup = false

  # create a new session
  $scope.createSession = (user) ->
    @http.post("/login.json", $scope.newSession).success (data) ->
      console.log data

  # destroy a session
  $scope.deleteSession = (session) ->
    @http.delete("/logout.json")

  $scope.showLogin = () ->
    $scope.login = true
    $scope.signUp = false
    $scope.focusOn()

  $scopeSignUp = () ->
    $scope.signUp = true
    $scope.login = false
    $scope.focusOn()

  $scope.focusOn = () ->
    setTimeout ->
      angular.element(".focusOn").trigger("focus")
    , 0

] 


PicnicApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $("meta[name=csrf-token]").attr("content")
]