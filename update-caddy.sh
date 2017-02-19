#!/bin/bash
sudo service caddy stop
curl https://raw.githubusercontent.com/atsvetkov/tsvetkov.io/master/Caddyfile > /var/www/Caddyfile
sudo service caddy start