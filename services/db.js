const { connect } = require("mongoose");
require("dotenv").config();
const MongoURL = process.env.MongoURL;

const Event = require("../models/Event");

(async () => {
    try {
        const db = await connect(MongoURL);
        console.log("DB connected to", db.connection.name);
    }
    catch (err){
        console.error(err);
    }
})()

module.exports = class {
    static async createEvent(_event){
        _event.IsActive = _event.IsActive || false;
        const event = new Event(_event);
        return (await event.save())._id;
    }
};