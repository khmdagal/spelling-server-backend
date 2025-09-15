const express = require('express');
const router = express.Router();
const { getAllSchools } = require('../controllers/schoolsControllers')
const { validateSignUpInput } = require('../middlewares/inputSanitazation')



router.route('/schools').get(validateSignUpInput, getAllSchools)

module.exports = router