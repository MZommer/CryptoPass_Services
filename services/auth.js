const DB = require("./db.js");

export default class Authorization {
    // Implement token autherization 
    static Authenticate(req, res){
        if (!req.headers.authorization) res.sendStatus(400)
    }
}