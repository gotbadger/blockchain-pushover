_          = require('underscore')
events     = require('events')
debug      = require('debug')('Processor')
Q          = require('q')

BLOCKCHAIN_TX_ADDRESS = "https://blockchain.info/tx/"

module.exports = class Processor
    constructor: (@address,@pushover) ->
        debug("New Instance For #{@address}");

    receivePromise: (message) ->
        debug("Recived Message")
        
        myOuput = _.findWhere(message.out, {addr:@address})
        body = "to #{@address}"
        ammount = parseInt(myOuput.value)/100000000
        # console.log(pp)
        return @sendPromise("#{ammount} BTC Recived",body,message.hash)

    sendPromise: (title,body,txid) ->
        debug("sending message")
        msg = {
            title: title,
            message: body,
            url: "#{BLOCKCHAIN_TX_ADDRESS}#{txid}",
            url_title: "View Transaction"
            sound: "cashregister"
        }
        return Q.nbind(@pushover.send, @pushover)(msg)
        # return Q(msg)

