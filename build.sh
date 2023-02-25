#!/bin/bash
echo DENO_VERSION=`curl --silent https://api.github.com/repos/denoland/deno/releases/latest | jq .tag_name` > .env

docker build .--no-cache --force-rm --cpuset-cpus 0-1
