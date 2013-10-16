_   = require('underscore')
Q	  = require('q')
bav = require('bitcoin-address') # bitcoin address validator
DBPromise = require('./db').getDBPromise()

errors = {
  INVALID_WALLET: "Wallet address is invalid"
  INVALID_TOKEN: "Pushover token is invalid"
  NOT_FOUND: "no record"
  ALREADY_EXISTS: "given device is already monitoring that address"
}

COLLECTION = "subs"

exports.errors = errors

exports.getAllPromise = () ->  
  DBPromise
  .then (db) ->
    search = db.collection(COLLECTION).find();
    Q.nbind(search.toArray,search)()

exports.addSubPromise = (token,wallet) ->
  if !bav.validate(wallet)
    return Q.reject(new Error(errors.INVALID_WALLET))

  # do slower pushover validate
  if !true
    return Q.reject(new Error(errors.INVALID_TOKEN))

  DBPromise
  .then (db) ->
    search = db.collection(COLLECTION).find({token:token,wallet:wallet});
    Q.nbind(search.count,search)()
    .then (count) ->
      if count != 0 then throw new Error(errors.ALREADY_EXISTS)
      # db.collection(COLLECTION).insert({token:token, wallet:wallet},{w:1},(err,rst) ->
      #     console.log(arguments)
      #   )
      col = db.collection(COLLECTION);
      Q.nbind(col.insert,col)({token:token, wallet:wallet},{w:1})
      .then (result) ->
        console.log(result)
      # Q.bind(col.insert,col)(,{w:1})
      # .then () ->
      #   console.log(arguments)
