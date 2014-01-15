Polycademy's NGINX Configuration
================================

Upstream from H5BP: [Nginx Server Configs](https://github.com/h5bp/server-configs-nginx)

NGINX configuration for Linux servers. Can also work for Mac or Windows, absolute paths and some unix specific configuration need to be changed. Best to test it before deploying!

This NGINX configuration works for one instance of NGINX. For multiple applications that have different global configurations in the conf.d or different mime.types or different nginx.conf, you should use some virtualisation to isolate the NGINX instances such as Docker and Dokku. However if the global configuration stays the same, and you're just adding another site to the same server, then just symlink each site's sites-available into the NGINX sites-enabled.

All file paths specified inside nginx.conf and any includes are relative paths to nginx.conf, so it this works with NGINX > 0.6.7. http://wiki.nginx.org/CoreModule#include It can also work with absolute paths.

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

1. Copy nginx.conf and mime.types over to NGINX root

```bash
cp nginx.conf NGINX_ROOT/nginx.conf
cp mime.types NGINX_ROOT/mime.types
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

SSL Configuration
-----------------

Once you start using SSL, you might as well make your entire site SSL so you don't get mixed content problems. Most of the SSL settings have already been setup in the nginx.conf. The site specific configuration require links to the certificate and key relevant to their particular domain. Multi domain or wildcard certificates can be specified in the `http` context inside nginx.conf.

Certificate chains need to be concatenated into one certificate. They are not specified separately. You should concatenate from Root > Intermediate > Domain and create a domain.pem file. This is the final file you'll use in the certificate directive. See http://nginx.org/en/docs/http/configuring_https_servers.html and http://www.digicert.com/ssl-support/pem-ssl-creation.htm for more information.

Multiple SSL certificates can be a problem for older browsers due them not supporting Server Name identification (SNI). The most reliable solution is for each website to listen to a different IP address. However this will not be a problem once people stop using Windows XP.

Todo
----

1. Refer to here for WS and WSS and Subdomain Rules: http://siriux.net/2013/06/nginx-and-websockets/