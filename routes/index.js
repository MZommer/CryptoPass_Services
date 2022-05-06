const routes = require('express').Router();
const v1 = require("./v1")

routes.use((req, res, next) => {
  	// impement authorization
 	next();
});

routes.use("/v1", v1);

module.exports = routes;