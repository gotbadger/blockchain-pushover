_		   = require('underscore')
events     = require('events')
debug 	   = require('debug')('Processor')
BLOCKCHAIN_TX_ADDRESS = "https://blockchain.info/tx/"
module.exports = class Processor
  
  constructor: (@address,@pushover) ->
  	debug("New Instance For #{@address}");
  
  receive: (message) ->
  	debug("Recived Message")

  send: (title,body,txid) ->
  	debug("sending message")
  	msg = {
  		url: "#{BLOCKCHAIN_TX_ADDRESS}#{txid}"
		url_title - "View Transaction"
  	}

