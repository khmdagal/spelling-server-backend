const { body } = require('express-validator');
exports.validateSignUpInput = [
  body('name').notEmpty().isLength({ min: 3 }).isString().withMessage('name is required and must be alphabetic'),
  body('role').notEmpty().isString().isAlpha().withMessage('Role status required'),
  body('username').notEmpty().isLength({ min: 5 }).isAlphanumeric().withMessage('user name is required and should be 5 character long'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
  body('school_id').notEmpty().isString().withMessage('Not valid input'),
  body('email').isEmail().withMessage('Email is invalid')
];

exports.sanitizeInput = (input) => {
  let scannedInputData;
  const dangerousInputs = /<[^>]+>/g

  /*
  First checking if the input is an array
  Second checking if the input is an object
  Lastly for strings
  */
  if (Array.isArray(input)) {
    const allValuesToString = input.map(value => String(value))
    scannedInputData = allValuesToString.some(value => value.match(dangerousInputs))
  } else if (typeof input === 'object' && input !== null && !Array.isArray(input)) {
    const getValuesAsArray = Object.values(input).map(value => String(value))
    scannedInputData = getValuesAsArray.some(value => value.match(dangerousInputs))
  } else {
    scannedInputData = input.match(dangerousInputs)
  }
  return scannedInputData ? true : false
}

