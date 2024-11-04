const DB = require("./db.js");

module.export = class Authorization {
    // Implement token autherization 
    static Authenticate(req, res){
        if (!req.headers.authorization) res.sendStatus(400)
    }
}