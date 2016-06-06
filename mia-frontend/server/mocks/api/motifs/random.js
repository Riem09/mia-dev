/*jshint node:true*/
module.exports = function(app) {
  var express = require('express');
  var apiMotifsRandomRouter = express.Router();

  apiMotifsRandomRouter.get('/', function(req, res) {
    res.send(
      
        {
          id: 0,
          name: "Random Motif",
          description: "",
          created_at: new Date(),
          updated_at: new Date(),
          image_icon: '',
          icon_url: '',
          hex_color: '000000'
        }
      
    );
  });

  apiMotifsRandomRouter.post('/', function(req, res) {
    res.status(201).end();
  });

  apiMotifsRandomRouter.get('/:id', function(req, res) {
    res.send({
      'api/motifs/random': {
        id: req.params.id
      }
    });
  });

  apiMotifsRandomRouter.put('/:id', function(req, res) {
    res.send({
      'api/motifs/random': {
        id: req.params.id
      }
    });
  });

  apiMotifsRandomRouter.delete('/:id', function(req, res) {
    res.status(204).end();
  });

  // The POST and PUT call will not contain a request body
  // because the body-parser is not included by default.
  // To use req.body, run:

  //    npm install --save-dev body-parser

  // After installing, you need to `use` the body-parser for
  // this mock uncommenting the following line:
  //
  //app.use('/api/api-motifs-random', require('body-parser').json());
  app.use('/api/motifs/random', apiMotifsRandomRouter);
};
