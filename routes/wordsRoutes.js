const express = require('express');
const { createWeeklyPractice, getWords, getAllWeeklyPractice } = require('../controllers/wordsControllers');
const { protect, adminOnly } = require('../controllers/authControllers')
const router = express.Router();


router.route('/:yearsSelected').get(protect, getWords)
router.route('/weeklypractice').post(adminOnly, createWeeklyPractice)
router.route('/weeklypractice/all').get(protect, adminOnly, getAllWeeklyPractice)
module.exports = router