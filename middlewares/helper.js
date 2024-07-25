const bcrypt = require('bcryptjs')


exports.correctPassword = async (enteredPassword, storedPassword) => {
    const correct = await bcrypt.compare(enteredPassword, storedPassword);
    return correct

}

