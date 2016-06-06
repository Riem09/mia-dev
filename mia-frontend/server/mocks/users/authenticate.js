/*jshint node:true*/
module.exports = function(app) {
  var express = require('express');
  var usersAuthenticateRouter = express.Router();

  usersAuthenticateRouter.get('/', function(req, res) {
    res.send({
      'users/authenticate': []
    });
  });

  usersAuthenticateRouter.post('/', function(req, res) {
    res.status(200).send({
      id: 0,
      name: 'Tester',
      email: 'me@local'
    });
  });

  usersAuthenticateRouter.get('/:id', function(req, res) {
    res.send({
      'users/authenticate': {
        id: req.params.id
      }
    });
  });

  usersAuthenticateRouter.put('/:id', function(req, res) {
    res.send({
      'users/authenticate': {
        id: req.params.id
      }
    });
  });

  usersAuthenticateRouter.delete('/:id', function(req, res) {
    res.status(204).end();
  });

  // The POST and PUT call will not contain a request body
  // because the body-parser is not included by default.
  // To use req.body, run:

  //    npm install --save-dev body-parser

  // After installing, you need to `use` the body-parser for
  // this mock uncommenting the following line:
  //
  //app.use('/api/users-authenticate', require('body-parser').json());
  app.use('/users/authenticate', usersAuthenticateRouter);
};
