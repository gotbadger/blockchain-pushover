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
    
    describe 'addSubPromise', ->
        it 'Wallet address should be validated', (done) ->
            done()

        it 'Pushover token should be validated', (done) ->
            done()