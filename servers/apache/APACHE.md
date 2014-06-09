Polycademy's APACHE Configuration
=================================

This APACHE configuration will not be tested anymore, it's here for legacy web servers.

To understand how the .htaccess file works, first you should check out H5BP's explanation: https://github.com/h5bp/html5-boilerplate/blob/master/doc/TOC.md

The .htaccess examples are meant to be reviewed and edited for your specific application. You need to take time to understand it. They are separated for different language runtimes.

Suppression of the "www" subdomain is forced, and this suppression happens before the index.php rewriting. This prevents the error of index.php rewriting when there is a "www" subdomain.