SiteFactories = angular.module("SiteFactories", [])

class Session

  constructor: (@http) ->

  create: (newSession) ->
    @http.post("/login.json", {user: newSession})

  delete: (session) ->
    @http.delete("/logout.json")

SiteFactories.service("Session", ["$http", Session])