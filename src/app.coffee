#main app

express = require('express')
port = if process.env.PORT? then process.env.PORT else 3000
monitor = require('./monitor')


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
monitor.init();




