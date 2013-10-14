should   = require('chai').should()
expect   = require('chai').expect
Processor = require('../src/processor')
Pushover = require('pushover-notifications');

describe 'Processor', ->
    worker = undefined
    data = {
        tx:"84d9e05253243c6c2cfcf68ed28091436a85e2507010976ebad08221e463042d"
        wallet:"test"
    }
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
            worker.Pushover.should.equal(data.wallet);
            done()
        
    describe 'send', ->
        it 'Should Send Message', (done) ->
            worker.send("Title","Body",data.tx)
            done();
        # it 'fail', (done) ->
        #     done("fail me")

	