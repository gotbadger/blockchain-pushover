should   = require('chai').should()
expect   = require('chai').expect
Subscriptions = require('../src/subscriptions')
Q        = require('q')
_        = require('underscore')
# use this for some direct meddling...
DBPromise = require('../src/db').getDBPromise()


data = {
    bad_wallet: "myWallet"
    wallet:	"1EXoDusjGwvnjZUyKkxZ4UHEf77z6A5S4P"
    token: "token"
}

describe 'Subscriptions', ->

    beforeEach (done) ->
        # empty the subs collection before each test
        DBPromise
        .done (db) ->
            col = db.collection(Subscriptions.collectionName);
            Q.nbind(col.remove,col)()
            .then () ->
                done()
        ,(err) ->
            done(err)


    afterEach (done) ->
        done()

    describe 'getAllPromise', -> 
        it 'Should get all current subs (none)', (done) ->
            Subscriptions.getAllPromise()
            .done (rst) ->
                rst.length.should.equal(0)
                done()
            ,(err) ->
                done(err) 
    
    describe 'addSubPromise', ->
        it 'Should Add Wallet when valid', (done) ->
            Subscriptions.addSubPromise(data.token,data.wallet)
            .done () -> 
                done()
            ,(err) ->
                done(err)

        it 'When adding an event should be fired', (done) ->
            Subscriptions.getEventEmitter().once Subscriptions.events.ANNOUNCE, (rst) ->
                rst.token.should.equal(data.token)
                rst.wallet.should.equal(data.wallet)
                done()
                
            Subscriptions.addSubPromise(data.token,data.wallet)
            .fail (err) ->
                done(err)

        it 'After adding getAllPromise should return the item just added', (done) ->
            Subscriptions.addSubPromise(data.token,data.wallet)
            .done () ->
                Subscriptions.getAllPromise()
                .then (rst) ->
                    rst.length.should.equal(1)
                    rst[0].token.should.equal(data.token)
                    rst[0].wallet.should.equal(data.wallet)
                    done()
            ,(err) ->
                done(err)

        it 'Bad wallet address should fail validation', (done) ->
            Subscriptions.addSubPromise(data.token,data.bad_wallet)
            .done (rst) ->
                done(new Error("should not reach this point"))
            ,(err) ->
                expect(err).to.exist
                expect(err.message).to.equal(Subscriptions.errors.INVALID_WALLET)
                done()

        it 'Pushover token should be validated'