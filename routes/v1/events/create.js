const DB = require.main.require("./services/db");

module.export = (req, res, next) => {
	DB.createEvent(req.body);
}
