const events = require('express').Router();
const create = require("./create");

events.post("/create", create);

module.exports = events;