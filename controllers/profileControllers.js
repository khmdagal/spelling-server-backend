const pool = require('../utils/db/db');
const { sanitizeInput } = require('../middlewares/inputSanitazation')

exports.getProfile = async (req, res, next) => {
    try {
        const { user_id } = req.user
      

        if (sanitizeInput(user_id)) {
            res.status(404).json({
                status: 'Faild',
                message: 'Invalid input 💪💪'
            })
        }

        const profile = (await pool.query(`select * from userprofile where user_id = $1`, [user_id]))

        if (profile.rowCount === 0) {
            res.status(500).json({
                status: 'Failed',
                message: 'Not found'
            })

        }
       
        res.status(200).json({
            status: 'Success',
            profile: profile.rows
        })
    } catch (error) {
        console.log(error)
        res.status(404).json({
            status: 'Failed'
        })
    }

};
exports.updateProfile = async (req, res, next) => {
    const client = await  pool.connect();
   try {
    
        const { profile_id } = req.params;
        const {newAvatarName} = req.body;

        

        if (sanitizeInput(profile_id, newAvatarName)) {
            res.status(404).json({
                status: 'Faild',
                message: 'Invalid input 💪💪'
            })
        }
        //  check if the user exists, if the update
        // limite number of updates per day to 3 or 4 times.

        const isProfileExist = (await client.query(`select * from userprofile where profile_id=$1`, [profile_id]))

        
        if (isProfileExist.rowCount === 0) {
            res.status(500).json({
                status: 'Failed',
                message: 'Not found'
            })

        }

        const updatedProfile = await client.query(`update userprofile set avatar_name=$1 where profile_id=$2`,[newAvatarName, profile_id])
       
   
          if (updatedProfile.rowCount !== 1) {
            res.status(500).json({
                status: 'Failed',
                message: 'Avatar name not changed!!'
            })

        }

       
        res.status(201).json({
            status: 'Success',
            newAvatarName
        })
     } catch (error) {
        console.log({error})
        res.status(404).json({
            status: 'Failed',
        })
     } finally{
        client.release();
     }

};

exports.createProfile = async (req, res, next) => {
    const client = await pool.connect()
    try {
        const { user_id, avatar_name } = req.body

        if (sanitizeInput(profile_id, req.body)) {
            res.status(404).json({
                status: 'Faild',
                message: 'Invalid input 💪💪'
            })
        }
        //  check if the user exists, if the update
        // limite number of updates per day to 3 or 4 times.

        const existingProfile = (await client.query(`select * from userprofile where user_id = $1`, [user_id]))

        if (existingProfile.rowCount !== 0) {
            res.status(500).json({
                status: 'Failed',
                message: 'profile already exist'
            })
        }


        const newProfile = (await client.query(`insert into userprofile (user_id,avatar_name) values($1,$2)`, [user_id, avatar_name]))
        
         if (newProfile.rowCount === 0) {
            res.status(500).json({
                status: 'Failed',
                message: 'Could not create your profile, please try again'
            })
        }

        res.status(201).json({
            status: 'Success',
            message: 'Profile Created'
        })

    } catch (error) {
        res.status(404).json({
            status: 'Failed'
        })

    } finally {
       client.release()
    }

};
exports.deleteProfile = async (req, res, next) => {
    try {
        const { profile_id } = req.params;

        if (sanitizeInput(profile_id)) {
            res.status(404).json({
                status: 'Faild',
                message: 'Invalid input 💪💪'
            })
        }
    } catch (error) {

    }

};