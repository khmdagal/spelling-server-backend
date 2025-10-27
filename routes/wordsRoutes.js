const express = require('express');
const { createWeeklyPractice, getWords, getAllWeeklyPractice, getWeeklyPracticeById, updateExampleSentence } = require('../controllers/wordsControllers');
const { protect, adminOnly } = require('../controllers/authControllers')
const router = express.Router();


router.route('/:yearsSelected').get(adminOnly, getWords)
router.route('/weeklypractice').post(adminOnly, createWeeklyPractice)
router.route('/weeklypractice/all').get(adminOnly, getAllWeeklyPractice)
router.route('/myweeklypractice/:practice_id/:school_id').get(protect, getWeeklyPracticeById)
router.route('/:word_id/example').put(adminOnly, updateExampleSentence)
module.exports = router