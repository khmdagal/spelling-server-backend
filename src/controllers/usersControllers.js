const pool = require('.././utils/db/db')

exports.getUsers = async (req, res, next) => {

    try {
        // Removing password field from the response
        const excludePassword = await pool.query(`
        select column_name
        from information_schema.columns
        where table_name = 'users' and column_name != 'password'
        `);
        const requiredColumns = excludePassword.rows.map(row => row.column_name).join(', ')

        const users = await (await pool.query(`select ${requiredColumns} from users`)).rows

        res.status(200).json({
            status: 'success',
            data: users
        })
    } catch (error) {
        console.log(error)
        next(error)
    }

}