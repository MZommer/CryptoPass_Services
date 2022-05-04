const routes = require('express').Router();
const bodyParser = require('body-parser');
const v1 = require("./v1")

routes.use(bodyParser.urlencoded({ extended: true }));
routes.use(bodyParser.json());


routes.use((req, res, next) => {
  	// impement authorization
 	console.log(`Requested: ${req.method} ${req.originalUrl}`);
 	next();
});

routes.use("/v1", v1);

module.exports = routes;