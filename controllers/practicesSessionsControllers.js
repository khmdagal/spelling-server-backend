const pool = require('../utils/db/db')
const { sanitizeInput } = require('../middlewares/inputSanitazation')

exports.createSession = async (req, res, next) => {

    try {

        if (sanitizeInput(req.body)) {
            res.status(404).json({
                status: 'Fail',
                message: 'Invalid input 💪💪'
            })
        }

        const data = {
            session_id: req.body.session_id,
            user_id: req.user.user_id,
            practice_id: req.body.practice_id,
            school_id: req.body.school_id,
            sessionData: req.body.sessionData,
            sessionScore: req.body.sessionScore
        }


        const response = await pool.query(`INSERT INTO sessions (
            session_id,
            user_id,
            practice_id,
            school_id,
            sessionData,
            session_score
            ) VALUES ($1,$2,$3,$4,$5,$6)`,
            [data.session_id,
            data.user_id,
            data.practice_id,
            data.school_id,
            data.sessionData,
            data.sessionScore])

        if (response.rowCount > 0) {

            return res.status(201).json({
                status: 'Success',
            })
        }



    } catch (error) {
        res.status(500).JSON({
            status: 'Failed'
        })
    }
};



// exports.getSessionsById = async (req, res, next) => {
//     console.log('===session by ID=>>', req)
// }
