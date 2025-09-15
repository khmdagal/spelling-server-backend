const bcrypt = require('bcryptjs')
const { promisify } = require('util')
const jwt = require('jsonwebtoken')
const pool = require('../utils/db/db');
const { validationResult } = require('express-validator');
const { correctPassword } = require('../middlewares/helper');
const { sanitizeInput } = require('../middlewares/inputSanitazation')

const createJwtToken = (id) => {
    const token = jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
    return token

}

const sendToken = async () => {

}

exports.signUp = async (req, res, next) => {
    try {
        // first checking any xss attacks
        if (sanitizeInput(req.body)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }

        const result = validationResult(req)
        console.log(result)
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

        // Checking if the user already exist
        const exitingUser = (await pool.query(`select username from users where username=$1`, [req.body.username])).rowCount
        if (exitingUser !== 0) {
            return res.status(400).json({
                status: 'fail',
                message: 'User already exists'
            })

        }

        // hashing the password and store the DB hashed password
        const hashedPassword = await bcrypt.hash(req.body.password, 12)

        const cleanNewUserData = {
            name: req.body.name, //1
            username: req.body.username, //2
            password: hashedPassword, //3
            role: req.body.role, //4
            school_id: req.body.school_id, //5
            email: req.body.email, //6
            approved: req.body.approved, //7
            created_at: new Date() //8
        }

        //creating the new user when the data passes the above checks
        pool.query(`insert into users(name,username,password,role,school_id,email,approved,created_at) 
                values($1,$2,$3,$4,$5,$6,$7,$8)             
    `, [cleanNewUserData.name,
        cleanNewUserData.username,
        cleanNewUserData.password,
        cleanNewUserData.role,
        cleanNewUserData.school_id,
        cleanNewUserData.email,
        cleanNewUserData.approved,
        cleanNewUserData.created_at])


        res.status(201).json({
            status: 'succuss',
            data: cleanNewUserData
        })
        next()
    } catch (err) {
        console.error(err);
        res.status(500).send(err);
        next(err)
    }


}

exports.logIn = async (req, res, next) => {
    try {
        
        if (sanitizeInput(req.body)) {
            return res.status(404).json({
                status: 'fail',
                message: 'Invalid input 💪💪'
            })
        }
        const { username, password } = req.body;


        // 1) check if username and password are not empty
        if (!username || !password) {
            res.status(401).send('Please provide username and password')
        }

        // 2) Check if the username exists
        const userNameExist = (await pool.query(`select user_id, name, username, school_id, password, approved from users where username=$1`, [username]));

        if (userNameExist.rowCount === 0) {
            return res.status(401).json({
                status: 'Unauthorized',
                message: 'Incorrect username or password'
            });
        }
        // 2.1) if username exits then compare the coming password to the encrypted password stored in the DB 
        const encryptedPassword = userNameExist.rows[0].password
        const correct = await correctPassword(password, encryptedPassword)


        if (!correct) {
            return res.status(401).json({
                status: 'Unauthorized',
                message: 'Incorrect username or password'
            });
        }

        // 3 if request body not empty, and username exists and password is correct

        const correctUserAccessed = {
            token: createJwtToken(userNameExist.rows[0].user_id),
            school_id: userNameExist.rows[0].school_id,
            approved: userNameExist.rows[0].approved,
            name: userNameExist.rows[0].name
        }
        const cookiesOption = {
            expires: new Date(Date.now() + process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000),
            secure: true,
            httpOnly: true
        }

        if (process.env.NODE_ENV !== 'production') {
            cookiesOption.secure = false
        }

        res.cookie('jwt', correctUserAccessed.token, cookiesOption)

        res.status(200).json({
            status: 'success',
            token: correctUserAccessed.token,
            school_id: correctUserAccessed.school_id,
            approved: correctUserAccessed.approved,
            name: correctUserAccessed.name
        })

    } catch (err) {
        console.error(err);
        res.status(500).send(err);
        next(err)
    }

};

exports.adminOnly = async (req, res, next) => {

    try {
        let token;
        if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
            token = req.headers["authorization"]?.split(' ')[1]
        }
        if (!token) next(new Error('Your not logged in'))

        // 2) Now lets verify the token

        const decoded = await jwt.verify(token, process.env.JWT_SECRET)
        // promisify(jwt.verify)(token, process.env.JWT_SECRET)

        const accessedTeacher = (await pool.query(`select user_id,name, approved from users where user_id=$1 and approved='true'`, [decoded.id])).rowCount

        if (!accessedTeacher) {
            return res.status(401).json({
                status: 'Not authorized',
                message: 'Your are not authorized for this task, please contact your school admin'
            })
        }

        //===========
        // Here for future I want to check if the password was changed after the token was issued
        // and then reject the access request if the password was changed
        //=========

        //THEN NOW GRANT ACCESS TO PROJECTED ROUTE

        req.user = accessedTeacher

    } catch (error) {

        console.log(error)
    }


    next()
}

exports.protect = async (req, res, next) => {
    // user should already logged in
    // get the user_id from the token sent when the user login in
    // check if the user_id is in the teacher table table
    // check if the teacher is approved
    // if the user exists and the and the teacher is approved the function should return true



    //======
    // 1) lets check of there is a token in the request headers
    let token;
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
        token = req.headers["authorization"]?.split(' ')[1]
    }
    if (!token) next(new Error('Your not logged in'))

    // 2) Now lets verify the token
    const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET)
    console.log("====>>>>", decoded)
    const accessedUser = (await pool.query(`select user_id,name from users where user_id=$1`, [decoded.id])).rowCount
    console.log('=+=+=+>>', accessedUser)
    if (!accessedUser) next(new Error('User not exist'))


    //===========
    // Here for future I want to check if the password was changed after the token was issued
    // and then reject the access request if the password was changed
    //=========

    //THEN NOW GRANT ACCESS TO PROJECTED ROUTE
    req.user = accessedUser
    next()
}

