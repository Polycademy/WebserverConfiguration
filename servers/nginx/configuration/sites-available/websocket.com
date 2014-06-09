map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

upstream websocket_server {

  server 127.0.0.1:9500;

}

server {
    
    location / {
        include proxy_params;
        include websocket_params;
        proxy_pass websocket_server;
    }

}