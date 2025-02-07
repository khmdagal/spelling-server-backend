const bcrypt = require('bcryptjs')


exports.correctPassword = async (enteredPassword, storedPassword) => {
    const correct = await bcrypt.compare(enteredPassword, storedPassword);
    return correct
}


const allowedOrigins = ['https://pwa-myspelling-prod-app.netlify.app', 'https://pwa-myspelling-qa-app.netlify.app'];

exports.corsOptions = {
    origin: function (origin, callback) {
        // If there's no origin (e.g., for Postman or server-to-server requests), request is blocked. and we passed minimal error message
        if (origin && allowedOrigins.indexOf(origin) !== -1) {
            callback(null, true);  // if there is origin in our listed origin, we allow the request.
        } else {
            callback(new Error('Not allowed 💪💪'), false);  // Block the request
        }
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
};
