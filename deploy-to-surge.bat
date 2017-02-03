@echo off

hugo --config=config.surge.toml --destination=public-surge

surge --project public-surge --domain https://tsvetkovio.surge.sh