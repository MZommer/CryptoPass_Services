const { MongoClient } = require('mongodb');
const MongoURL = process.env.MongoURL;
const client = new MongoClient(MongoURL, { useNewUrlParser: true, useUnifiedTopology: true });

class DB {
    static createEvent(){
        event = {
            
        }
        client.connect(function(err, db) {
            if (err) throw err;
            var dbo = db.db("CryptoPass");
            dbo.collection("Events").insertOne(event, function(err, res) {
              if (err) throw err;
              db.close();
              console.log("Event created");
            });
          });
    }
}

module.exports = DB;