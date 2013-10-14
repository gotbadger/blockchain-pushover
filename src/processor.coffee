_		   = require('underscore')
events     = require('events')
debug 	   = require('debug')('Processor')


module.exports = class Processor
  
  constructor: (@address) ->
  	debug("New Instance For #{@address}")
  
  receive: (message) ->
  	debug("Recived Message")
