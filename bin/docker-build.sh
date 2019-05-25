#!/bin/bash

COMMIT_HASH=$(git rev-parse --short HEAD)
docker build \
    -t rorono/development:latest \
    -t rorono/development:${COMMIT_HASH} \
    .
