#!/bin/bash
curl https://raw.githubusercontent.com/atsvetkov/tsvetkov.io/master/Caddyfile > /var/www/Caddyfile
sudo service caddy restart