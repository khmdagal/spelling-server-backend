const express = require('express');
const router = express.Router();

const {isLoggedIn, protect} = require('../controllers/authControllers')
const {getLeaderBoardPerPracticeId} = require('../controllers/leaderBoardControllers')

router.route('/getLeaderBoard/:practice_id').get(protect, getLeaderBoardPerPracticeId)

module.exports = router