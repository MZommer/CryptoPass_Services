const events = require("express").Router();
const DB = require.main.require("./services/db.js");

events.get("/page/:page?", async (req, res, next) => {
    
});

events.get("/:id", async (req, res, next) => {
    const event = await DB.getEvent(req.params.id);
    if (event)
        return res.status(200).json(event);
    next();
});

events.post("/create", async (req, res) => {
    const id = await DB.createEvent(req.body);
	res.status(200).json({
        success: true,
        message: "Event created successfully",
		id,
    });
});

module.exports = events;