const express = require('express');
const cors = require('cors');
const app = express();

const {corsOptions} = require('./middlewares/helper')
const wordsRoutes = require('./routes/wordsRoutes')
const usersRoutes = require('./routes/userRoutes')
const schoolsRoutes = require('./routes/schoolsRoutes')

app.use(express.json());

app.use(cors(corsOptions));

app.use((req, res, next) => {
    next()
})

// API endpoint
app.use('/api/v1/spelling/words', wordsRoutes);
app.use('/api/v1/spelling/users', usersRoutes);
app.use('/api/v1/spelling/schools', schoolsRoutes);

module.exports = app