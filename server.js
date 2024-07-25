
const dotenv = require('dotenv')
dotenv.config()
const app = require('./app')
const port = 3000
setTimeout(() => {
    console.log("DB is connected")
}, 2000)

app.listen(port,()=> console.log(`server is up and running on port ${port}`))