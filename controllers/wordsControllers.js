const pool = require('../utils/db/db')

exports.getWords = async (req, res, next) => {

    try {
        const selectedYears = req.params.yearsSelected;
        const words = await (await pool.query(`select  word_id, ${selectedYears} from spelling_table`)).rows
        res.status(200).json({
            status: 'success',
            words
        })
    } catch (error) {
        console.log(error)
        next(error)
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

    const practice = {
        name: req.body.name,
        description: req.body.description,
        practice_id: req.body.practice_id,
        words: req.body.words,
        school_id: req.body.school_id,
        class_id: req.body.class_id,
        created_at: req.body.created_at,
        expires_in: req.body.expires_in
    }

    try {
        const createdPractice = await pool.query(`
            insert into weeklypractice(practice_id,name,description,words,school_id,class_id,created_at,expires_in)
            values($1,$2,$3,$4,$5,$6,$7,$8)
            `, [practice.practice_id,
        practice.name,
        practice.description,
        practice.words,
        practice.school_id,
        practice.class_id,
        practice.created_at,
        practice.expires_in])

        return res.status(201).json({
            status: 'success',
            createdPractice
        })

    } catch (error) {
        res.send(error)
    }
    next()
}

exports.getWeeklyPracticeById = async (req, res, next) => {
    try {
        const { practice_id, school_id } = req.params
        console.log({practice_id},{school_id})
        const response = await pool.query(`select name,description,words from weeklypractice where practice_id=$1 and school_id=$2`, [practice_id,school_id]);
        res.status(200).json({
            status: 'success',
            myAssignment: response.rows[0]
        })

    } catch (error) {
        res.send(error)
    }
    next()
}
