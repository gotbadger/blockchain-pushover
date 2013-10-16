#main app

express = require('express')
port = if process.env.PORT? then process.env.PORT else 3000
# monitor = require('./monitor')
subs = require('./subscriptions')



app = express();

app.configure () ->
  app.use express.bodyParser()
  app.use express.methodOverride()

app.get '/',(req, res) ->
  res.writeHead 203
  res.end();

 # add route to allow people to subscribe for updates
 # add route to remove a subscription
app.listen(port);
# monitor.init();

subs.addSubPromise("foo","1HbL1pi9ufqDyYxcWeETWF9j5999HiukbJ")
.done (rst)->
    console.log(rst)
,(err) ->
    console.log("error",err)

subs.getAllPromise()
.done (rst)->
    console.log(rst)
,(err) ->
    console.log("error",err)

console.log("app started")