#!/usr/bin/env bash

docker run -e SERVER_ENDPOINT=localhost:8080 \
        -e ACCESS_KEY=minioadmin \
        -e SECRET_KEY=minioadmin \
        -e ENABLE_HTTPS=0 \
        --net=host \
        minio/mint

