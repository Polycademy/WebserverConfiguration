Polycademy's NGINX Configuration
================================

Upstream from H5BP: [Nginx Server Configs](https://github.com/h5bp/server-configs-nginx)

This NGINX configuration works for one instance of NGINX. For multiple applications that have different global configurations in the conf.d or different mime.types or different nginx.conf, you should use some virtualisation to isolate the NGINX instances such as Docker and Dokku. However if the global configuration stays the same, and you're just adding another site to the same server, then just symlink each site's sites-available into the NGINX sites-enabled.

Global Configuration (Done Once)
--------------------------------

1. Copy nginx.conf and mime.types over to NGINX root

```bash
cp nginx.conf NGINX_ROOT/nginx.conf
cp mimes.types NGINX_ROOT/mimes.types
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