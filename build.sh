#!/bin/bash
set -eux

cd "$(dirname "$0")"

tagname=`curl --silent https://api.github.com/repos/denoland/deno/releases/latest | jq --raw-output ".tag_name"`
current_build_digest=$(docker image ls tackn/deno:"$tagname" -q)

if [ -n "$current_build_digest" ]; then
  echo "Build already exists for $tagname"
else
  docker build . \
    --no-cache \
    --force-rm \
    --build-arg DENO_VERSION="$tagname" \
    --tag tackn/deno:"$tagname" \
    --cpuset-cpus 0-1

  docker push tackn/deno:"$tagname"
  docker tag tackn/deno:${tagname} tackn/deno:latest
  docker push tackn/deno:latest
fi
