should   = require('chai').should()
expect   = require('chai').expect
Processor = require('../src/processor')
Pushover = require('pushover-notifications')
Q        = require('q')

data = {
    tx:"84d9e05253243c6c2cfcf68ed28091436a85e2507010976ebad08221e463042d"
    wallet:"test"
    apiToken:"apptoken"
    userKey:"userkey"
}

# i will return a dummy work that will call done when i try and send a message
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

describe 'Processor', ->
    worker = undefined
    # before (done) ->
    #     console.log("before")
    #     done()
    beforeEach (done) ->
        # console.log("lol")
        push = new Pushover({
            token: process.env.APPTOKEN
            user: process.env.TESTUSERKEY
        });
        worker = new Processor(data.wallet,push)
        # console.log("hit")
        done()

    # afterEach (done) ->
    #     done()
    
    describe 'constructor', ->
        it 'Address should be one supplied', (done) ->
            worker.address.should.equal(data.wallet);
            done()
        
    describe 'sendPromise', ->
        it 'Should Send Message', (done) ->
            
            generateSendDummy().sendPromise("Title","Body",data.tx)
            .done (rst) ->
                rst.status.should.be = 1
                # check message body contents
                console.log(rst.called_with)
                done()
            ,(err) ->
                done(err)

        it 'Should Return Error Messages', (done) ->
            error = new Error("Test Error")
            generateSendDummy(error).sendPromise("Title","Body",data.tx)
            .done (rst) ->
                done(new Error("should not reach this point"))
            ,(err) ->
                expect(err).to.exist
                console.log(err)
                done()

    