#simple wrapper for mongo db deals with connecting and such

Client = require('mongodb').MongoClient
Q = require('q')

DB = null

exports.getDBPromise = () ->
  if DB?
    Q(DB)
  else
    Q.nbind(Client.connect,Client)("mongodb://127.0.0.1:27017/wallet-monitor")
    .then (db) ->
      DB = db
      return db