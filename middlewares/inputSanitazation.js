const { body } = require('express-validator');
exports.validateSignUpInput = [
  body('name').notEmpty().isLength({ min: 3 }).isString().withMessage('name is required and must be alphabetic'),
  body('role').notEmpty().isString().isAlpha().withMessage('Role status required'),
  body('username').notEmpty().isLength({ min: 5 }).isAlphanumeric().withMessage('user name is required and should be 5 character long'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
  body('school_id').notEmpty().isNumeric().withMessage('Not valid input'),
  body('email').isEmail().withMessage('Email is invalid')
];