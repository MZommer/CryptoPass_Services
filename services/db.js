const { connect } = require("mongoose");
const MongoURL = process.env.MongoURL;

(async () => {
    try {
        const db = await connect(MongoURL);
        console.log("DB connected to", db.connection.name)
    }
    catch (err){
        console.error(err)
    }
})()

module.exports = class {
    static createEvent(){
        // Implement Mongoose
    }
};