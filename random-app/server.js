const express = require('express');

const dirWebRoot = 'public';
const port = Number(process.env.PORT || 5000);
const app = express();

app.use(express.static(dirWebRoot)).listen(port);

console.log('Static web server runnin on port: ' + port);
