PhotoFactories = angular.module("PhotoFactories", [])

class Photo

  constructor: (@http) ->

PhotoFactories.service("Photo", ["$http", Photo])