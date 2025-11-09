const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { getUsers } = require('../controllers/usersControllers')
const { signUp, logIn } = require('../controllers/authControllers')
const { validateSignUpInput } = require('../middlewares/inputSanitazation')
const { adminOnly, isLoggedIn, logout } = require('../controllers/authControllers')


router.route('/').get(adminOnly, getUsers)
router.route('/signup').post(validateSignUpInput, signUp)
router.route('/login').post(validateSignUpInput, logIn)
router.route('/isLoggedIn').get(isLoggedIn)
router.route('/logout').get(logout);

module.exports = router