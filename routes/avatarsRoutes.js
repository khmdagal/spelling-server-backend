const express = require('express');
const router = express.Router();

const {protect} = require('../controllers/authControllers');
const {getAvatars} = require('../controllers/avatarControllers')

router.route('/getAavatars').get(protect,getAvatars)
router.route('/getMyAavatars/:avatar_name').get(protect,getAvatars)







module.exports = router