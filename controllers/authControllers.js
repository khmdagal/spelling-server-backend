const bcrypt = require('bcryptjs')
const crypto = require('crypto');
const { promisify } = require('util')
const jwt = require('jsonwebtoken')

const pool = require('../utils/db/db');
const { validationResult } = require('express-validator');
const { correctPassword } = require('../middlewares/helper');
const { sanitizeInput } = require('../middlewares/inputSanitazation');

const createJwtToken = (id) => {
    const token = jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
    return token

}
const generateUUID = () => {
    return crypto.randomBytes(16).toString('hex');
}

const sendToken = (user, statusCode, res) => {
    const token = createJwtToken(user.user_id);

    const cookieOptions = {
        expires: new Date(
            Date.now() + process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000
        ),
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: process.env.NODE_ENV === 'production' ? 'None' : 'Lax',
    };

    // send cookie
    res.cookie('jwt', token, cookieOptions);

    // Optionally, don’t send token in response (for security)
    res.status(statusCode).json({
        status: 'success',
        school_id: user.school_id,
        approved: user.approved,
        name: user.name,
    });
};


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

        const newUserId = String(generateUUID())

        console.log({ newUserId });

        const cleanNewUserData = {
            user_id: newUserId,
            name: req.body.name,
            username: req.body.username,
            password: hashedPassword,
            role: req.body.role,
            school_id: req.body.school_id,
            email: req.body.email,
            approved: req.body.approved,
            created_at: new Date()
        }

        //creating the new user when the data passes the above checks
        pool.query(`insert into users(user_id,name,username,password,role,school_id,email,approved,created_at) 
                values($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
            [cleanNewUserData.user_id,
            cleanNewUserData.name,
            cleanNewUserData.username,
            cleanNewUserData.password,
            cleanNewUserData.role,
            cleanNewUserData.school_id,
            cleanNewUserData.email,
            cleanNewUserData.approved,
            cleanNewUserData.created_at])


        console.log('==>>>', cleanNewUserData.user_id)

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

        const user = userNameExist.rows[0];

        sendToken(user, 200, res);

        next();

    } catch (err) {
        console.error(err);
        res.status(500).send(err);
        next(err)
    }

};



exports.protect = async (req, res, next) => {
    try {
        let token;

        if (!token && req.cookies && req.cookies.jwt) {
            token = req.cookies.jwt;
        }

       
        if (!token) {
            return res.status(401).json({ status: 'fail', message: 'You are not logged in' });
        }

        const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

        const userQuery = await pool.query(`SELECT user_id, name, role, approved FROM users WHERE user_id=$1`, [decoded.id]);
        const user = userQuery.rows[0];
        
        if (!user) {
            return res.status(401).json({ status: 'fail', message: 'User no longer exists' });
        }

        req.user = user;
        next();

    } catch (err) {
        console.error('Auth protect failed:', err);
        res.status(401).json({ status: 'fail', message: 'Invalid or expired token' });
    }
};


exports.adminOnly = async (req, res, next) => {

    await exports.protect(req, res, async (err) => {
        
        if (err) return next(err);

        if (!req.user.approved) {
          
            return res.status(403).json({ status: 'fail', message: 'Access denied — Teachers only' });
        }
        next();
    });
};

exports.isLoggedIn = async (req, res) => {
    try {
        let token;
        if (req.cookies && req.cookies.jwt) {
            token = req.cookies.jwt;
        }
        if (!token) return res.status(401).json({ status: 'fail', message: 'Not logged in' });

        const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
        const user = (await pool.query('SELECT user_id, approved FROM users WHERE user_id=$1', [decoded.id])).rows[0];

        if (!user) return res.status(401).json({ status: 'fail', message: 'User no longer exists' });

        res.status(200).json({ status: 'authenticated', admin: user.approved });

    } catch (err) {
        res.status(401).json({ status: 'fail', message: 'Invalid token' });
    }
};

exports.logout = (req, res) => {
    res.status(200)
    .clearCookie('jwt')
    .json({ status: 'loggedout' });
};


