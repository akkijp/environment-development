#!/bin/bash

COMMIT_HASH=$(git rev-parse --short HEAD)

docker push rorono/development:latest 
docker push rorono/development:githash-${COMMIT_HASH}
