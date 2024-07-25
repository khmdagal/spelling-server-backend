const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { getUsers } = require('../controllers/usersControllers')
const { signUp, logIn } = require('../controllers/authControllers')
const { validateSignUpInput } = require('../middlewares/inputSanitazation')
const { protect } = require('../controllers/authControllers')

router.route('/').get(protect, getUsers)
router.route('/signup').post(validateSignUpInput, signUp)
router.route('/login').post(validateSignUpInput, logIn)

module.exports = router