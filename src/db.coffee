#simple wrapper for mongo db deals with connecting and such

Client = require('mongodb').MongoClient
Q = require('q')
# by default just use a local db for testing
CONNECTION_STRING = if process.env.CONNECTION_STRING? then process.env.CONNECTION_STRING else "mongodb://127.0.0.1:27017/wallet-monitor-test"
DB = null

exports.getDBPromise = () ->
  if DB?
    Q(DB)
  else
    Q.nbind(Client.connect,Client)(CONNECTION_STRING)
    .then (db) ->
      DB = db
      return db