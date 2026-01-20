const express = require('express');
const router = express.Router();
const {getAllClassBySchool , getClassById, createClass} = require('../controllers/classesControllers');
const {isLoggedIn, adminOnly} = require('../controllers/authControllers')

router.route('/getAllClassBySchool/:school_id').get(adminOnly, getAllClassBySchool);
router.route('/createClass/:schoolId').post(isLoggedIn, adminOnly, createClass);
//router.route('/getClassById/:school_id/:class_id').get(adminOnly, getClassById);


module.exports = router