UserFactories = angular.module("UserFactories", [])

class User

  constructor: (@http) ->

  create: (newUser) ->
    @http.post("/users.json", {user: newUser})

  show: (user) ->
    @http.get("/users/:id.json")

  update: (user) ->
    @http.put("/users/:id.json", {user: user})

  delete: (user) ->
    @http.delete("/users/:id.json", {user: user})

UserFactories.service("User", ["$http", User])