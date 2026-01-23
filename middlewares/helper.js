const bcrypt = require('bcryptjs');
const crypto = require('crypto');

exports.correctPassword = async (enteredPassword, storedPassword) => {
    const correct = await bcrypt.compare(enteredPassword, storedPassword);
    return correct
}

const allowedOrigins = ['https://pwa-myspelling-prod-app.netlify.app', 'https://pwa-myspelling-qa-app.netlify.app'];

exports.corsOptions = {
    origin: function (origin, callback) {
        if(!origin){
           return callback(null,true)
        }
        
        if (origin && !allowedOrigins.includes(origin)) { 
           return callback(new Error('Not allowed 💪💪'), false);
        }

        return callback(null, true); 
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
};


exports.generateUUID = () => {
    return crypto.randomBytes(16).toString('hex');
}