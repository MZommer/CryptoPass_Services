const v1 = require('express').Router();
const events = require("./events");

v1.use("/events", events);

module.exports = v1;