#!/bin/bash
tagname=`curl --silent https://api.github.com/repos/denoland/deno/releases/latest | jq --raw-output .tag_name`
envname=DENO_VERSION=${tagname}

if [ -f .env ]; then
    check=`cat .env`
else
    check="Not File"
fi

if [[ $envname == $check ]]; then
  echo "Build Exists"
else
  echo ${envname} > .env
  docker build . --no-cache --force-rm --tag tackn/deno:${tagname} --cpuset-cpus 0-1
fi
