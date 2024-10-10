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

exports.getMyWeeklyPractice = async (req, res, next) => {
    // add here parameter of the which class
    const { class_id } = req.params.class_id

    try {
        const practice = await pool.query(`select *  from weeklypractice where class_id=$1`, [class_id])
        res.status(200).json({
            status: 'success',
            data: practice.rows
        })
    } catch (error) {
        console.log(error)
        next(error)
    }

}

exports.getAllWeeklyPractice = async (req, res, next) => {
    try {
        const response = await pool.query(`select practice_id,name,description,words,school_id,class_id,created_at,expires_in from weeklypractice`)
        res.status(200).json({
            status: 'success',
            data: response.rows
        })
    } catch (error) {
        console.log(error)

    }

}


exports.getAllWeeklyPractice = async (req, res, next) => {
    try {
        const result = await (await pool.query(`SELECT * FROM weeklypractice`)).rows

        console.log('===>>>', result.rows)

        // Send response only once
        res.status(200).json({
            status: 'success',
            data: result
        });


    } catch (error) {
        console.log("Error fetching weekly practice:", error);
        // next(error); // Call next to trigger error middleware if needed
    }
    next()
};

exports.getWeeklyPracticeById = async (req, res, next) => {
    // this was test improve it very well
    try {
        const { practice_id } = req.params
        const practiceSession = await pool.query(`select words from weeklypractice where practice_id=$1`, [practice_id]);
        practiceSession.rows[0].map(el => res.send(el))


    } catch (error) {
        res.send(error)
    }
    next()
}


exports.getAllWeeklyPractice = async (req, res, next) => {
    try {
        const result = (await pool.query(`SELECT practice_id,name,description,words,school_id,class_id,created_at,expires_in FROM weeklypractice`)).rows
        return res.status(200).json({
            status: 'success',
            result
        })
    } catch (error) {
        res.send(error)
    }
    next()
}

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