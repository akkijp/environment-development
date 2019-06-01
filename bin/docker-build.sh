#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
COMMIT_HASH=$(git rev-parse --short HEAD)

docker build \
    -t rorono/development:latest \
    -t rorono/development:${COMMIT_HASH} \
    ${SCRIPT_DIR}/../src
