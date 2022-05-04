const express = require('express');
const routes = require('./routes');

const app = express();

const PORT = process.env.PORT || 8080;

app.set('trust proxy', true);


app.use((req, res, next) => { // HTTPS redirection
  if (!req.secure)
  	return res.redirect('https://' + req.get('host') + req.url);
  next();
});

app.use('/', routes);

app.use((err, req, res, next) => {
    res.status(err.status || 400).json({
        success: false,
        message: err.message || 'An error occured.',
        errors: err.error || [],
    });
});

app.use((req, res) => {
    res.status(403).json({ success: false, message: 'Forbidden' });
});

app.listen(PORT, () => {
console.log(`
--------------------------------------------------
Server: CPS\nEnviroment: DEV\nPort: ${PORT}
--------------------------------------------------`);
});