#!/bin/bash
set -x
if [ $TRAVIS_BRANCH == 'master' ] ; then
    cd public
    git init
        
    git remote add deploy "deploy@tsvetkov.io:/var/www/tsvetkov.io"
    git config user.name "Travis CI"
    git config user.email "iammamba@gmail.com"
    
    git add .
    git commit -m "Deployed by Travis CI"
    git push --force deploy master
else
    echo "Not deploying, since this branch isn't master."
fi