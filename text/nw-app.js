var static = require('node-static');

var server = new static.Server();

require('http').createServer(function (request, response) {
    request.addListener('end', function () {
        //
        // Serve files!
        //
        server.serve(request, response);
    }).resume();
}).listen(8001);
