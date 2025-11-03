const pool = require('../utils/db/db')
const { sanitizeInput } = require('../middlewares/inputSanitazation')

exports.getWords = async (req, res, next) => {

    try {

        const selectedYears = req.params.yearsSelected;
        if (sanitizeInput(selectedYears)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }
        const words = (await pool.query(`select * from words where class_year = $1`, [selectedYears])).rows
        res.status(200).json({
            status: 'success',
            words
        })
    } catch (error) {
        console.log(error)
        next(error)
    }

}

exports.updateExampleSentence = async (req, res, next) => {
    const client = await pool.connect();
    try {
        const { word_id, newExmaples } = req.body

        if (sanitizeInput(req.body)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }

        if (!word_id || !newExmaples) {
            return res.status(400).json({ status: 'error', message: 'word_id and example_sentence are required' })
        }

        const exitingWordId = await client.query('select word_id from words where word_id=$1', [word_id])

        if (exitingWordId.rowCount !== 1) {
            return res.status(400).json({
                status: 'fail',
                message: "Word not found."
            })
        }


        const updatedExamples = await client.query('update words set example=$1 where word_id=$2 returning *', [newExmaples, exitingWordId.rows[0].word_id])

        if (updatedExamples.rowCount === 0) {
            return res.status(400).json({
                status: 'fail',
                message: "Example not updated"
            })
        }
        res.status(201).json({
            status: 'success'
        })

        next()
    } catch (err) {
        console.error('Error executing query', err.stack);
        throw err;
    } finally {
        client.release();
    }
}

exports.getAllWeeklyPractice = async (req, res, next) => {
    try {
        const result = (await pool.query(`SELECT * FROM weeklypractice`)).rows

        res.status(200).json({
            status: 'success',
            assignments: result
        });


    } catch (error) {
        console.log("Error fetching weekly practice:", error);
    }
    next()
};

exports.createWeeklyPractice = async (req, res, next) => {

    if (sanitizeInput(req.body)) {
        return res.status(404).json({
            status: 'fail',
            message: 'Invalid input 💪💪'
        })
    }

    const practice = {
        "practice_id": req.body.practice_id,
        "school_id": req.body.school_id,
        "details": {
            "title": `${req.body.title}`,
            "description": `${req.body.description}`,
            "words": JSON.parse(req.body.words),
            "targetgroup": `${req.body.targetgroup}`,
            "created_at": `${req.body.created_at}`,
            "expires_in": `${req.body.expires_in}`
        }
    }

    
    try {
        const createdPractice = await pool.query(`
            insert into weeklypractice(practice_id, school_id, assignment)
            values($1,$2,$3)
            `, [practice.practice_id, practice.school_id, practice.details])


        return res.status(201).json({
            status: 'success',
            createdPractice
        })

    } catch (error) {
        console.log('Error creating practice:', error)
        res.status(500).json({
            status: 'error',
            message: 'Something went wrong creating the practice',
            error: error.message
        });
    }
    next()
}

exports.getWeeklyPracticeById = async (req, res, next) => {
    try {

        if (sanitizeInput(req.params)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }

        const { practice_id, school_id } = req.params

        const practiceId = await pool.query('select practice_id from weeklypractice where practice_id=$1', [practice_id])

        if (practiceId.rowCount === 0) {
            return res.status(404).json({ status: 'error', message: 'Practice not found, please use a valid practice id' })
        }

        const existingPractice = practiceId.rows;

        const response = await Promise.all(
            existingPractice.map(async (practice) => {
                return await pool.query('select * from weeklypractice where practice_id=$1 and school_id=$2', [practice.practice_id, school_id])
            })
        )

        res.status(200).json({
            status: 'success',
            myAssignment: response.map(result => result.rows[0])
        })

    } catch (error) {
        res.send(error)
    }
    next()
}
