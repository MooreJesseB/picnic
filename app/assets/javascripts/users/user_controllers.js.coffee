UserControllers = angular.module("UserControllers", [
  "ngResource"
])

class UsersCtrl

  constructor: (@scope, @http, @resource, @location) ->
    @user = @resource("/users/:id.json")
    @login = false
    @signup = false

  create: (newUser) ->
    console.log "Clicked User Create!"
    console.log newUser
    console.log @User
    @Usercreate newUser, (data) =>
      console.log data
      @location.path "/requests"


UserControllers.controller("UsersCtrl", ["$scope", "$http", "$resource", "$location", UsersCtrl])


