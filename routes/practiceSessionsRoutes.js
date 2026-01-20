const express = require('express');
const router = express.Router();

const {isLoggedIn, protect} = require('../controllers/authControllers')
const {createSession, getSessionsById} = require('../controllers/practicesSessionsControllers')

router.route('/createSession').post(protect, createSession);

module.exports = router;