const pool = require('../utils/db/db')
const { body, validationResult } = require('express-validator');
const { generateUUID } = require('../middlewares/helper')

const { sanitizeInput } = require('../middlewares/inputSanitazation');



// exports.getClassById = async (req, res, next) => {

//     if (sanitizeInput(req.params)) {
//         return res.status(404).json({
//             status: 'fail',
//             message: 'Invalid input 💪💪'
//         })
//     }

//     const { school_id, class_id } = req.params
//     try {
//         const schoolId = (await pool.query(`select school_id from schools where schoold_id=1`, [school_id]))

//         if (schoolId.rowCount === 0) {
//             return res.status(404).json({ status: 'error', message: 'Practice not found, please use a valid school id' })
//         }

//         const existingSchoolId = schoolId.rows;

//         const class_year = (await pool.query(`select * from classes where class_id=1 and school_id=2`, [class_id, existingSchoolId]))


//         res.status(200).json({
//             status: 'success',
//             class_year
//         })
//     } catch (error) {
//         console.log(error)
//         next(error)
//     }
// }

exports.getAllClassBySchool = async (req, res, next) => {

    const schoolId = req.params.school_id

    if (sanitizeInput(schoolId)) {
        return res.status(404).json({
            status: 'fail',
            message: 'Invalid input 💪💪'
        })
    }


    const result = validationResult(schoolId)

    if (!result.isEmpty()) {
        const errors = result.array().map((el) => {
            return {
                message: el.msg,
                field: el.path
            }
        })

        return res.status(400).json({
            status: 'fail',
            message: errors
        })
    }

    try {
        const response = (await pool.query(`select school_id from schools where school_id=$1`, [schoolId]))

        if (response.rowCount === 0) {
            return res.status(404).json({ status: 'error', message: 'Not found, please use a valid school id' })
        }

        const existingSchoolId = response.rows[0].school_id;

        const allClasses = ((await pool.query(`select * from classes where school_id=$1`, [existingSchoolId])).rows)


        res.status(200).json({
            status: 'success',
            allClasses
        })
    } catch (error) {
        console.log(error)
        next(error)
    }
}

exports.createClass = async (req, res, next) => {
    const client = await pool.connect();

    try {
        const { schoolId } = req.params

        if (sanitizeInput(req.params)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }

        if (sanitizeInput(req.body)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }

        const result = validationResult(body)

        if (!result.isEmpty()) {
            const errors = result.array().map((el) => {
                return {
                    message: el.msg,
                    field: el.path
                }
            })

            return res.status(400).json({
                status: 'fail',
                message: errors
            })
        }

        const newClassId = String(generateUUID())
        const response = (await client.query(`select school_id from schools where school_id=$1`, [schoolId]))

        if (response.rowCount === 0) {
            return res.status(404).json({ status: 'error', message: 'Not found, please use a valid school id' })
        }

        const existingSchoolId = response.rows[0];

        const newCleanClassData = {
            class_id: newClassId,
            class_name: req.body.class_name,
            school_id: existingSchoolId.school_id,
            enrolled_students: req.body.enrolled_students
        }

        const classes = (await client.query(`insert into classes(class_id, class_name, school_id, enrolled_students) 
            values ($1,$2,$3,$4)`,
            [newCleanClassData.class_id,
            newCleanClassData.class_name,
            newCleanClassData.school_id,
            newCleanClassData.enrolled_students
            ]))


        res.status(201).json({
            status: 'success',
            message: `${newCleanClassData.class_name} has been successfully created `
        })
    } catch (error) {
        console.log(error)
        next(error)
    } finally {
        client.release();
    }
}