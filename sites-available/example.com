# www to non-www redirect -- duplicate content is BAD:
# https://github.com/h5bp/html5-boilerplate/blob/5370479476dceae7cc3ea105946536d6bc0ee468/.htaccess#L362
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name
server {

  # don't forget to tell on which port this server listens
  listen 80;
  listen [::]:80 ipv6only=on;
  listen 443 ssl;
  listen [::]:443 ipv6only=on;

  # listen on the www host
  server_name www.example.com;

  # and redirect to the non-www host (declared below)
  return 301 $scheme://example.com$request_uri;

}

server {
  
  #ipv4 and ipv6
  listen 80;
  listen [::]:80 ipv6only=on;
  listen 443 ssl;
  listen [::]:443 ipv6only=on;

  # Accessible from http://example.com, this will require mapping hostname to ip address on dev server
  # Also specifies all subdomains
  server_name example.com *.example.com;

  # Path for static files
  root /www/example.com/;

  # Index search file to serve if in a directory
  index index.html index.htm;

  #Specify a charset
  charset utf-8;

  # Custom error pages, this should be handled on the app layer
  # error_page 404 /404.html;
  # error_page 500 502 503 504 /50x.html;

  # Include the recommended base config
  include conf.d/base.conf;

  # Force ssl
  # if ($ssl_protocol = "") {
  #   return 301 https://example.com$request_uri;
  # }

  # Try to get the file, or directory and fallback on the front controller pattern
  # location / {
  #   try_files $uri $uri/ /index.php;
  # }

  # You need to specify what the CGI proxy will be, this example uses PHP
  # To prevent execution of non php files. We check if the $uri is there, and if so, return 404
  # location ~* \.php$ {
  #   include fastcgi.conf;
  #   try_files $uri =404;
  #   fastcgi_pass unix:/tmp/php-fpm.sock;
  # }

}