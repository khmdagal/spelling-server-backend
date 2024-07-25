const express = require('express');
const cors = require('cors');
const app = express();

const wordsRoutes = require('./routes/wordsRoutes')
const usersRoutes = require('./routes/userRoutes')

app.use(express.json());
app.use(cors());

app.use((req, res, next) => {
    next()
})

// API endpoint
app.use('/api/v1/spelling/words', wordsRoutes);
app.use('/api/v1/spelling/users', usersRoutes)

module.exports = app