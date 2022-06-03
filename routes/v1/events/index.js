const events = require("express").Router();
const DB = require.main.require("./services/db.js");

events.get("/search/:page?", async (req, res, next) => {
    req.body.page = req.params.page || 1;
    res.json(await DB.searchEvent(req.body));
    next();
});

events.get("/:id", async (req, res, next) => {
    const event = await DB.getEvent(req.params.id);
    if (event)
        return res.json(event);
    next();
});

events.post("/create", async (req, res, next) => {
    const id = await DB.createEvent(req.body);
	res.json({
        success: true,
        message: "Event created successfully",
		id,
    });
    next();
});

module.exports = events;