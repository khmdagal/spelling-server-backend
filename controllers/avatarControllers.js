const pool = require('../utils/db/db');
const {sanitizeInput} = require('../middlewares/inputSanitazation')

exports.getAvatars = async (req, res, next) => {
    try {
    
        const allAvatars = (await pool.query('select * from avatars')).rows
        res.status(200).json({
            status: 'Success',
            allAvatars
        })
    } catch (error) {
        res.status(404).json({
            status: 'Failed'
        })
    }

};

exports.getMyAvatar = async (req, res, next) =>{
    try {
        const {avatar_name} = req.params

        if(sanitizeInput(avatar_name)){
            res.status(404).json({
                status:'Failed',
                message: 'Invalid input 💪💪'
            })
        }

        const myAvatar = (await pool.query(`select $1 from avatars`, [avatar_name]))

        if(myAvatar.rowCount === 0){
            res.status(500).json({
                status:'Failed',
                message: 'Not found'
            })

        }

        res.status(200).json({
            status:'Success',
            myAvatar : myAvatar.rows
        })
        
    } catch (error) {
         res.status(404).json({
            status: 'Failed'
        })
    }
}