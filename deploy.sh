#!/bin/bash
git clone https://github.com/atsvetkov/tsvetkov.io.git /var/www/tsvetkov.io/temp
mkdir /var/www/tsvetkov.io/temp/themes
git clone https://github.com/atsvetkov/hyde.git /var/www/tsvetkov.io/temp/themes/hyde
~/work/bin/hugo -s /var/www/tsvetkov.io/temp -d /var/www/tsvetkov.io/html
rm -rf /var/www/tsvetkov.io/temp
echo done!