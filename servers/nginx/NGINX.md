Polycademy's NGINX Configuration
================================

Tested with: 1.7.1 (we need tests for this...)

./applications
--------------

These are example applications.

./setup
-------

These are simple bash scripts for installing this setup, mainly used for the automated tests.

./configuration
---------------

This is an example layout of `/etc/nginx/`.

The nginx.conf file is the main configuration file for NGINX.

The mimes.types folder hosts all the mime types of files that can be served.

The conf.d folder hosts modularised global configuration of the server. These are included in site-specific configuration. You can also add your own configuration modules.

The sites-available folder hosts all site specific configuration. Index the file names by their domain name. "example.com" would server both "www.example.com and example.com". You can also add configuration specific to subdomains such as "test.example.com". The example has a no-default site specific configuration. This is to drop requests for empty hosts. You can use this to replace the default site specific configuration that comes with an NGINX installation.

NGINX works on an hierarchical configuration system. So directives inside the site specific configuration overwrite the directives in the nginx.conf.

Once you have setup your server name to match your desired domain name, you may need to manipulate your hosts file. If you are still in development, you should create virtual hosts inside your hosts file pointing back to 127.0.0.1. Then the server_name will be used to decide which server block to use.

In order to use example.com on the development server, one would write this:

```
# Virtual Hosts inside etc/hosts
127.0.0.1 dev.example.com
```

In production you should remove those virtual hosts, since a bought domain name will work normally when routed to your server's external ip address.

This configuration uses the "www-data" user. Make sure this user exists, and set the appropriate permissions in the default www directory. Such as `chown -R www-data:www-data /www`. Confirm that the owner has read, write and execute permissions.

The example.com configuration expects there to be a root www folder at "/www", this will contain all web source code and static files.

Becareful with the uploaded file execution exploit: https://nealpoole.com/blog/2011/04/setting-up-php-fastcgi-and-nginx-dont-trust-the-tutorials-check-your-configuration/

Global Configuration (Done Once)
--------------------------------

1. Copy nginx.conf, mime.types and fastcgi_params over to NGINX root

```bash
cp nginx.conf NGINX_ROOT/nginx.conf
cp mime.types NGINX_ROOT/mime.types
cp fastcgi_params NGINX_ROOT/fastcgi_params
```

2. Copy from conf.d to the NGINX root's conf.d

```bash
cp -r conf.d/* NGINX_ROOT/conf.d/
```

It's also possible to establish symlinks to the NGINX root directory instead of copying the files. This allows you maintain your configurations inside this repository, and any changes to it will automatically affect NGINX once you reload it. To do so make sure when you are symlinking it, you are symlinking absolutely.

Per Site Configuration (Done for Every New Site)
------------------------------------------------

Each project repository should have its own sites-available configuration. Currently this repo just has an example.

1. Establish symlinks from sites-available to NGINX root's sites-enabled (while resolving PWD, since symlinks require absolute paths)

```bash
ln -s `pwd`/sites-available/example.com NGINX_ROOT/sites-enabled/example.com
```

NGINX by default comes with a default site specific configuration. You should replace that with the no-default configuration supplied in the current sites-available. This prevents having a default site which should not be available for production web applications.

```bash
rm NGINX_ROOT/sites-enabled/default
cp sites-available/no-default NGINX_ROOT/sites-available/no-default
ln -s NGINX_ROOT/sites-available/no-default NGINX_ROOT/sites-enabled/no-default
```

Development Configuration
-------------------------

During development, you should switch off the cache-file-descriptors.conf file. The `open_file_cache` directives will cache your files during the HTTP cycle, so you won't see the latest updates to your source code. This is located in your per site configuration file, simply comment out this directive:

```
  #include conf.d/cache-file-descriptors.conf;
```

SSL Configuration
-----------------

Once you start using SSL, you might as well make your entire site SSL so you don't get mixed content problems. Most of the SSL settings have already been setup in the nginx.conf. The site specific configuration require links to the certificate and key relevant to their particular domain. Multi domain or wildcard certificates can be specified in the `http` context inside nginx.conf.

Certificate chains need to be concatenated into one certificate. They are not specified separately. You should concatenate from Root > Intermediate > Domain and create a domain.pem file. This is the final file you'll use in the certificate directive. See http://nginx.org/en/docs/http/configuring_https_servers.html and http://www.digicert.com/ssl-support/pem-ssl-creation.htm for more information.

Multiple SSL certificates can be a problem for older browsers due them not supporting Server Name identification (SNI). The most reliable solution is for each website to listen to a different IP address. However this will not be a problem once people stop using Windows XP.

TCP Stack Tuning
----------------

See: http://dak1n1.com/blog/12-nginx-performance-tuning

Supported Protocols
-------------------

FastCGI
Proxy
uWSGI
WebSocket
(Eventually libchan)