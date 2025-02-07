const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { getUsers } = require('.././controllers/usersControllers') // Import getUsers function from usersControllers
const { signUp, logIn } = require('.././controllers/authControllers') // Import signUp and logIn functions from authControllers
const { validateSignUpInput } = require('.././middlewares/inputSanitazation') // Import validateSignUpInput function from inputSanitazation
const { adminOnly } = require('.././controllers/authControllers') // Import adminOnly function from authControllers

router.route('/').get(adminOnly, getUsers)
router.route('/signup').post(validateSignUpInput, signUp)
router.route('/login').post(validateSignUpInput, logIn)

module.exports = router