SiteControllers = angular.module("SiteControllers", [
  "ngResource"
])

class SitesCtrl

  constructor: (@scope, @http, @resource, @location, @Session, @User) ->
    console.log @User
    @login = false
    @signup = false
  
  createSession: (newSession) ->
    console.log @Session
    @Session.create newSession
    this.redirectToRequests()

  createUser: (newUser) ->
    @User.create newUser, (data) ->
    this.redirectToRequests()

  redirectToRequests: () ->
    console.log "redirecting to Requests"
    @location.path "/requests"

  showLogin: () ->
    console.log "login form"
    @login = true
    @signUp = false
    @focusOn()

  showSignUp: () ->
    console.log "Signup form"
    @signUp = true
    @login = false
    @focusOn()

  focusOn: () ->
    console.log "autofocus attempt"
    setTimeout -> 
      angular.element(".focusOn").trigger('focus')
    , 0

SiteControllers.controller("SitesCtrl", ["$scope", "$http", "$resource", "$location", "Session", "User", SitesCtrl])


