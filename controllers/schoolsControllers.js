const pool = require('../utils/db/db')

// getall schools example
exports.getAllSchools = async (req, res, next) => {
    try {
        const schools = (await pool.query(`select * from schools`)).rows
        res.status(200).json({
            status: 'success',
            schools
        })
    } catch (error) {
        console.log(error)
        next(error)
    }
}