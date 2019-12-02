const http = require('http'),
    faye = require('faye');

const bayeux = new faye.NodeAdapter({mount: '/faye', timeout: 45});

// Handle non-Bayeux requests
const server = http.createServer(function(request, response) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end('Hello, non-Bayeux request');
});

['handshake', 'subscribe', 'unsubscribe', 'publish', 'disconnect'].forEach((ev) => {
    bayeux.on(ev, function() {
        console.log(ev, JSON.stringify(arguments, null, 2));
    });
});

bayeux.attach(server);
server.listen(9292);