const DB = require.main.require("./services/db.js");

module.exports = (req, res, next) => {
	DB.createEvent(...req.body);
}
