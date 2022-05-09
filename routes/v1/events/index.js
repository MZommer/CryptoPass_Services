const events = require("express").Router();
const DB = require.main.require("./services/db.js");

events.post("/create", async (req, res) => {
    const id = await DB.createEvent(req.body);
	res.status(200).json({
        success: true,
        message: "Event created successfully",
		id,
    });
});

module.exports = events;