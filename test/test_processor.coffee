should   = require('chai').should()
expect   = require('chai').expect
Processor = require('../src/processor')
Q        = require('q')
_        = require('underscore')

data = {
    tx:"84d9e05253243c6c2cfcf68ed28091436a85e2507010976ebad08221e463042d"
    wallet:"myWallet"
    apiToken:"apptoken"
    userKey:"userkey"
    title:"Title"
    body:"Body"
}

# i will return a dummy work that will call done when i try and send a message
# TODO: Get rid of globals used
generateSendDummy = (fail) ->
    return new Processor(data.wallet,generateMockPushover(fail))

generateMockPushover = (fail) ->
    return {
            token: data.apiToken
            user: data.userKey
            send: (obj, fn)->
                # perhaps add message validator?
                if(fail)
                    fn.call(null, fail, {});
                else
                    fn.call(null, undefined, {
                        "status":1,
                        "request":"somerequestid",
                        "called_with": obj #does not exist in real version use for debugging
                        })
    }
generateMockTransaction = (myWallet) ->
    return {
      "hash": "6bef14550fd2bba197ed280481a33d9aca5c6333de6945aba9ea9337aa864fc4",
      "vin_sz": 1,
      "vout_sz": 2,
      "lock_time": "Unavailable",
      "size": 257,
      "relayed_by": "127.0.0.1",
      "tx_index": 93522974,
      "time": 1381844505,
      "inputs": [
        {
          "prev_out": {
            "value": 1000000,
            "type": 0,
            "addr": "SomeOriginAddress"
          }
        }
      ],
      "out": [
        {

          # 0.005 BTC
          "value": 500000,
          "type": 0,
          "addr": myWallet
        },
        {
          "value": 450000,
          "type": 0,
          "addr": "someOtherGuy"
        }
      ]
    }
    


describe 'Processor', ->

    beforeEach (done) ->
        done()

    afterEach (done) ->
        done()
    
    describe 'constructor', ->
        it 'Address should be one supplied', (done) ->
            dummy = generateSendDummy()
            dummy.address.should.equal(data.wallet);
            done()
        
    describe 'sendPromise', ->
        it 'Should Send Message', (done) ->
            
            generateSendDummy().sendPromise(data.title,data.body,data.tx)
            .done (rst) ->
                rst.status.should.be = 1
                # check message body contents
                expect(_.keys(rst.called_with).length).to.equal(5)
                rst.called_with.title.should.equal(data.title)
                rst.called_with.message.should.equal(data.body)
                rst.called_with.url.should.equal("https://blockchain.info/tx/#{data.tx}")
                rst.called_with.url_title.should.equal('View Transaction')
                rst.called_with.sound.should.equal('cashregister')
                done()
            ,(err) ->
                done(err)

        it 'Should Return Error Messages', (done) ->
            error = new Error("Test Error")
            generateSendDummy(error).sendPromise(data.title,data.body,data.tx)
            .done (rst) ->
                done(new Error("should not reach this point"))
            ,(err) ->
                expect(err).to.exist
                expect(err).to.equal(error)
                done()
    describe 'recivePromise', ->
        it 'Should decode transaction info into a valid message', (done) ->
            transaction = generateMockTransaction(data.wallet)
            generateSendDummy().receivePromise(transaction)
            .done (rst) ->
                rst.status.should.be = 1
                # check message body contents
                # console.log(rst.called_with)             
                rst.called_with.title.should.equal("0.005 BTC Recived")
                rst.called_with.message.should.equal("to #{data.wallet}")
                done()
            ,(err) ->
                done(err)

    