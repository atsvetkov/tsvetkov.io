@echo off

hugo --config config.gh-pages.toml
git add public
git commit -m "updated published static site"
git push
git subtree push --prefix public origin gh-pages