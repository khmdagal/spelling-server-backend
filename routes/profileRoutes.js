const express = require('express');
const router = express.Router();

const {isLoggedIn, protect, adminOnly} = require ('../controllers/authControllers');
const {createProfile,getProfile,updateProfile,deleteProfile , getAvatars} = require ('../controllers/profileControllers')


router.route('/createProfile').post(protect, createProfile)
router.route('/getProfile').get(protect, getProfile)
router.route('/updateProfile/:profile_id').put(protect,updateProfile);
router.route('/getAvatars').get(protect, getAvatars)

module.exports = router;