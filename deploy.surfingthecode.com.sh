#!/bin/bash
git clone https://github.com/atsvetkov/tsvetkov.io.git /var/www/surfingthecode.com/temp
git clone https://github.com/atsvetkov/hyde.git /var/www/surfingthecode.com/temp/themes/hyde
~/work/bin/hugo --config=/var/www/surfingthecode.com/temp/config.surfingthecode.com.toml -s /var/www/surfingthecode.com/temp -d /var/www/surfingthecode.com/html
rm -rf /var/www/surfingthecode.com/temp
echo done!