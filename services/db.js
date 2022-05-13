const { connect } = require("mongoose");
require("dotenv").config();
const HashIds = new (require("hashids"))(process.env.HashKey);
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
        return HashIds.encodeHex((await Event.create(_event))._id.toString());
    }
    static async getEvent(id){
        let event = await Event.findById(HashIds.decodeHex(id)).catch(err => console.error(err.message));
        event = event.toObject();
        delete event._id;
        event.id = id;
        return event;
    }
    static async searchEvent(searchParams){
        // to implement
    }
};