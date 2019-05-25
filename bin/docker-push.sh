#!/bin/bash

COMMIT_HASH=$(git rev-parse --short HEAD)
docker push rorono/development:${COMMIT_HASH}
