_   = require('underscore')
Q	  = require('q')
bav = require('bitcoin-address') # bitcoin address validator
events = require('events')

DBPromise = require('./db').getDBPromise()

# setup some helpers so we dont have magic strings floating around
ERRORS = {
  INVALID_WALLET: "Wallet address is invalid"
  INVALID_TOKEN: "Pushover token is invalid"
  NOT_FOUND: "no record"
  ALREADY_EXISTS: "given device is already monitoring that address"
}

COLLECTION = "subs"


# events issued are:
# ANNOUNCE - new sub that should be listened to
# REVOKE - currently listend for sub to be removed
EVENTS = {
  REVOKE: "Revoke"
  ANNOUNCE: "Announce"
}


_eventEmitter = new events.EventEmitter()

exports.collectionName = COLLECTION
exports.errors = ERRORS
exports.events = EVENTS

exports.getEventEmitter = -> _eventEmitter

exports.getAllPromise = () ->  
  DBPromise
  .then (db) ->
    search = db.collection(COLLECTION).find();
    Q.nbind(search.toArray,search)()

exports.addSubPromise = (token,wallet) ->
  if !bav.validate(wallet)
    return Q.reject(new Error(ERRORS.INVALID_WALLET))

  # do slower pushover validate
  if !true
    return Q.reject(new Error(ERRORS.INVALID_TOKEN))

  DBPromise
  .then (db) ->
    search = db.collection(COLLECTION).find({token:token,wallet:wallet});
    Q.nbind(search.count,search)()
    .then (count) ->
      if count != 0 then throw new Error(ERRORS.ALREADY_EXISTS)
      col = db.collection(COLLECTION);
      Q.nbind(col.insert,col)({token:token, wallet:wallet},{w:1})
      .then (results) ->
        _.each results, (elm) ->
          _eventEmitter.emit(EVENTS.ANNOUNCE,elm)
          # send sub notification for this new user
          # retuning resolved is enough so no need to return antyhing

exports.removeSubPromise = (token,wallet) ->
  if !bav.validate(wallet)
    return Q.reject(new Error(ERRORS.INVALID_WALLET))

  # do slower pushover validate
  if !true
    return Q.reject(new Error(ERRORS.INVALID_TOKEN))

  DBPromise
  .then (db) ->
    search = db.collection(COLLECTION).find({token:token,wallet:wallet});
    Q.nbind(search.count,search)()
    .then (count) ->
      if count != 1 then throw new Error(ERRORS.NOT_FOUND)
      col = db.collection(COLLECTION);
      Q.nbind(col.remove,col)({token:token, wallet:wallet},1)
      .then (results) ->
        console.log("revoke",results)
        _.each results, (elm) ->
          _eventEmitter.emit(EVENTS.REVOKE,elm)
          # send sub notification for this new user
          # retuning resolved is enough so no need to return antyhing
