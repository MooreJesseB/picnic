UserControllers = angular.module("UserControllers", [
  "ngResource"
])

class UsersCtrl

  constructor: (@scope, @http, @resource, @location) ->
    @User = @resource("/users/:id.json")
    @login = false
    @signup = false

  create: (newUser) ->
    console.log "Clicked User Create!"
    console.log newUser
    console.log @User
    @Usercreate newUser, (data) =>
      console.log "data", data

  show: (userId) ->
    @User.get {userId: userId}


UserControllers.controller("UsersCtrl", ["$scope", "$http", "$resource", "$location", UsersCtrl])


