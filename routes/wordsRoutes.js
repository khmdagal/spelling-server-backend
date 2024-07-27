const express = require('express');
const { getWords, createPracticeSession, getPracticeSessions, getPracticeSessionById } = require('../controllers/wordsControllers');
const { protect, adminOnly } = require('../controllers/authControllers')
const router = express.Router();


router.route('/:yearsSelected').get(protect, getWords)
router.route('/practice-sessions').post(adminOnly, createPracticeSession)
router.route('/practice-sessions/:practice_id').get(protect,getPracticeSessionById)
router.route('/practice-sessions').get(protect, getPracticeSessions)
module.exports = router