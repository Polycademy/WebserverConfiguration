var zmq = require('zmq');
var MongrelRequest = require('./mongrel_request').MongrelRequest;

var workerId = new Buffer('b0c3c3e0-c5e1-11e3-9c1a-0800200c9a66');

//we're pulling from Mongrel's push and publishing to Mongrel's subscribe
var requestSock = zmq.socket('pull');
var responseSock = zmq.socket('pub');

console.log('Worker is pulling from 1337 and 1339');
console.log('Worker is publishing to 1338 and 1340');

/**
 * Connect is used here because it's used for volatile connections.
 * Connect will setup a message queue for each endpoint.
 * Bind is used for more stable endpoints, the upstream hub will use bind instead.
 * **bind** is for a stable hub, where volatile clients **connect** to
 * Based off the server.conf, we're using 1338 & 1337 for HTTP and 1339 & 1340 for HTTPS
 */
requestSock.connect('tcp://127.0.0.1:1337');
requestSock.connect('tcp://127.0.0.1:1339');
responseSock.connect('tcp://127.0.0.1:1338');
responseSock.connect('tcp://127.0.0.1:1340');

//setup identity for publish socket so we let Mongrel 2 know who's publishing
responseSock.setsockopt('identity', workerId);

requestSock.on('message', function (message) {

    //received messages are binary objects to be converted into strings
    console.log(message.toString());

    //parse the tnetstring into a request object
    var request = new MongrelRequest(message);
    console.log(request);

    //reply back
    responseSock.send("blah");

});