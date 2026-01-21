const express = require('express');
const router = express.Router();

const {isLoggedIn, protect, adminOnly} = require ('../controllers/authControllers');
const {createProfile,getProfile,updateProfile,deleteProfile} = require ('../controllers/profileControllers')


router.route('/createProfile').post(isLoggedIn,protect, createProfile)
router.route('/getProfile').get(protect, getProfile)
router.route('/updateProfile/:profile_id').put(protect,updateProfile);
router.route('deleteProfile/:profile_id').delete(adminOnly,deleteProfile);

module.exports = router;