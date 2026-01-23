const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');

const app = express();

const {corsOptions} = require('./middlewares/helper')
const wordsRoutes = require('./routes/wordsRoutes')
const usersRoutes = require('./routes/userRoutes')
const schoolsRoutes = require('./routes/schoolsRoutes')
const classesRoutes = require('./routes/classesRoutes')
const practiceSessionsRoutes = require('./routes/practiceSessionsRoutes')
const leaderBoard = require('./routes/leaderBoardRoutes')
const profileRoutes = require('./routes/profileRoutes')

app.use(express.json());
app.use(cookieParser());
app.use(cors(corsOptions));
app.options('*', cors(corsOptions))

app.use((req, res, next) => {
    next()
})

// API endpoint
app.use('/api/v1/spelling/words', wordsRoutes);
app.use('/api/v1/spelling/users', usersRoutes);
app.use('/api/v1/spelling/schools', schoolsRoutes);
app.use('/api/v1/spelling/classes', classesRoutes);
app.use('/api/v1/spelling/practicesSessions',practiceSessionsRoutes);
app.use('/api/v1/spelling/leaderBoard',leaderBoard)
app.use('/api/v1/spelling/profile',profileRoutes)

module.exports = app