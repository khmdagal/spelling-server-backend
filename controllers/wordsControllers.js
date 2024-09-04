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

exports.getPracticeSessions = async (req, res, next) => {

    try {
        const practiceSessions = await pool.query(`select *  from weeklyspellingpractice`)
        res.status(200).json({
            status: 'success',
            data: practiceSessions.rows
        })
    } catch (error) {
        console.log(error)
        next(error)
    }

}

exports.createPracticeSession = async (req, res, next) => {
    const todayDate = new Date()

    const session = {
        practice_id: String(Date.now()),
        words: req.body.words,
        created_at: todayDate,
        expires_in: todayDate // fix here

    }
    console.log(session)
    try {
        const practiceSession = await pool.query(`
            insert into weeklyspellingpractice(practice_id,words,created_at,expires_in)
            values($1,$2,$3,$4)
            `, [session.practice_id, session.words, session.created_at, session.expires_in])

        res.status(201).json({
            status: 'success',
            practiceSession
        })

    } catch (error) {
        res.send(error)
    }
    next()
}

exports.getPracticeSessionById = async (req, res, next) => {
    // this was test improve it very well
    try {
        const { practice_id } = req.params
        console.log(practice_id)
        const practiceSession = await pool.query(`select words from weeklyspellingpractice where practice_id=$1`, [practice_id]);
        console.log(practiceSession.rows[0])
        practiceSession.rows[0].map(el => res.send(el))


    } catch (error) {
        res.send(error)
    }
    next()
}