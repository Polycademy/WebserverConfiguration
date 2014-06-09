<?php

require 'Slim/Slim.php';
\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

// the root of the server is actually index.php
// these 3 routes are legitimate
// * fastcgi.com
// * fastcgi.com/
// * fastcgi.com/index.php
// * fastcgi.com/index.php/
// preferred: fastcgi.com or fastcgi.com/ (choose one)
$app->get('/', function () {
    echo 'fastcgi.com homepage';
});

// here we have a controller which doesn't exist as a real file
// these 2 routes are legitimate:
// * fastcgi.com/controller
// * fastcgi.com/index.php/controller
// preferred: fastcgi.com/controller
$app->get('/controller', function () {
    echo 'fastcgi.com controller';
});

// here we have a "simulated" directory which actually doesn't exist either
// NGINX in this case will try to remove the trailing slash, because it does not detect a "real" directory
// these 2 routes are legitimate:
// * fastcgi.com/directory
// * fastcgi.com/directory/
// * fastcgi.com/index.php/directory
// * fastcgi.com/index.php/directory/
// preferred: fastcgi.com/directory (because you shouldn't be simulating directories!)
$app->get('/directory/', function () {
    echo 'fastcgi.com directory';
});

// if your preferences are different from mine, then you'll need to change the NGINX location rules!

$app->run();